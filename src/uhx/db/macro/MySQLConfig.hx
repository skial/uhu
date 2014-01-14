package uhx.db.macro;

import haxe.crypto.Md5;
import haxe.ds.StringMap.StringMap;
import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import uhx.macro.KlasImpl;
import uhx.macro.help.Hijacked;

using Lambda;
using Reflect;
using StringTools;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class MySQLConfig {
	
	private static var BUILT:Array<String> = [];

	public static function handler(cls:ClassType, fields:Array<Field>, ?isRoot:Bool = false):Array<Field> {
		//trace( 'mysql macro handler' );
		//trace( cls.path() );
		var nfields = [];
		
		var hasID = false;
		var hasManager = false;
		
		for (field in fields) {
			
			field = field.copy();
			field = field.qualify();
			
			nfields.push( field );
			
			if (field.name == 'manager') hasManager = true;
			
			switch (field.kind) {
				case FVar(t, e) if (t != null):
					var value = '' + t.toType();
					var ntype = t;
					var tpath = ntype.asTypePath();
					
					if (field.name == 'id' && tpath.sub == 'Int') {
						ntype = macro :sys.db.Types.SId;
						hasID = true;
					}
					
					if (value.startsWith('TEnum')) {
						ntype = ntype = macro:sys.db.Types.SData<$t>;
					}
					
					if (tpath.name == 'Array') {
						
						switch (tpath.params[0]) {
							case TPType(ctype): 
								var pcls:ClassType = switch (ctype.toType()) {
									case TInst(t, _): t.get();
									case _: null;
								}
								if (pcls != null && pcls.rmeta( ':db' ) != null) {
									
									var base:BaseType = ctype.toType().getParameters()[0].get();
									var altT:ComplexType = TPath( { name: DBConfig.getAltName( base ), pack: base.pack, params: [] } );
									
									ntype = macro:sys.db.Types.SData<$t>;
									
									nfields.push( 
										'${field.name}Ids'.mkField().mkPrivate()
										.toFVar(macro:sys.db.Types.SData<Array<Int>>)
										.addMeta( ':noCompletion'.mkMeta() )
									);
									
									nfields.push( 
										field.mkGetter( macro { 
											return cast Lambda.array( $e { Context.parse('${DBConfig.getAltPath( base )}.manager.search($$id in ${field.name}Ids )', field.pos) } );
										} ).addMeta( ':noCompletion'.mkMeta() )
									);
									
									nfields.push(
										field.mkSetter( macro { 
											$i { field.name + 'Ids' } = [for (value in v) value.id];
											return v;
										} ).addMeta( ':noCompletion'.mkMeta() )
									);
									
									field.kind = FProp('get', 'set', t, e);
									field.meta.push( ':skip'.mkMeta() );
									field.meta.push( ':isVar'.mkMeta() );
									
									continue;
									
								} else {
									
									ntype = macro:sys.db.Types.SData<$t>;
									
								}
								
							case TPExpr(etype): trace( etype );
						}
						
					}
					
					field.kind = FVar(ntype, e);
					
				case FVar(t, e) if (e != null):
					t = Context.toComplexType( Context.typeof( e ) );
					
				case FFun(method):
					for (arg in method.args) arg.type = arg.type.qualify();
					
				case _:
			}
			
		}
		
		/*if (cls.superClass != null) {
			nfields.push(
				'super${cls.superClass.get().name}'.mkField().mkPrivate()
			);
		}*/
		
		if (!hasID) {
			nfields.push( 
				'id'.mkField().mkPublic()
				.toFVar( TPath( { name: 'Types', pack: ['sys', 'db'], sub: 'SId', params: [] } ) ) 
			);
		}
		
		if (BUILT.indexOf( cls.path() ) == -1) {
			// Unfortuantly I have to recreate the class, and destroy the original, macro trickery!
			KlasImpl.registerForReType( 
				function(_, _) {
					var td = handleReType(cls, nfields);
					if (!hasManager && td != null) {
						td.fields.push(
							'manager'.mkField().mkPublic().mkStatic()
							.toFVar( null, Context.parse( 'new sys.db.Manager<${DBConfig.getAltPath( cls )}>(${DBConfig.getAltPath( cls )})', Context.currentPos() ) )
						);
					}
					return td;
				} 
			);
			BUILT.push( cls.path() );
		}
		
		return fields;
	}
	
	private static function handleReType(cls:ClassType, fields:Array<Field>):TypeDefinition {
		var meta = [for (m in cls.meta.get()) if (m.printMetadata().toLowerCase().indexOf('klas') == -1) m].concat( [ 
			{ name: ':native', params: [macro $v { cls.path() } ], pos: cls.pos }, 
			{ name: ':table', params: [macro $v { cls.name } ], pos: cls.pos }, 
			':KLAS_SKIP'.mkMeta(),
		] );
		
		var td = {
			name: DBConfig.getAltName( cls ),
			pack: cls.pack,
			pos: cls.pos,
			//meta: cls.meta.get().concat( [ { name: ':native', params: [macro $v{cls.path()}], pos: cls.pos }, ':KLAS_SKIP'.mkMeta() ] ),
			meta: meta,
			kind: TDClass( { name: 'Object', pack: ['sys', 'db'], params: [] }, [for (i in cls.interfaces) if (i.t.get().name != 'Klas') i.t.get().toTypePath()], false ),
			params: cls.toTypeParamDecls(),
			isExtern: false,
			fields: fields.copy()
		};
		
		try {
			// Some how two `handleReType` callbacks are being called, even with :KLAS_SKIP meta,
			// and two different BUILT checks.
			if (Context.getType( td.path() ) != null) return null;
		} catch (e:Dynamic) {
			
		}
		
		if (td.fields.exists( 'new' )) {
			// All I want to FRACKING do is insert `super()`, but no,
			// I have to destroy the original constructor, but not 
			// before copying its body, modify it & then recreate
			// it & then insert it back into the copied fields array!!!!
			// I'm asking for to much :)
			var nes:Array<Expr> = [];
			td.fields.remove( td.fields.get('new') );
			switch (fields.get( 'new' ).kind) {
				case FFun(method):
					switch (method.expr.expr) {
						case EBlock(es): nes = es.copy();
						case EUntyped( { expr:EBlock(es) } ): nes = es.copy();
						case _: trace( method.expr.expr );
					}
					
				case _:
			}
			nes.unshift( macro super() );
			td.fields.push( 
				'new'.mkField().mkPublic().toFFun()
				.body( { expr: EBlock(nes), pos: fields.get('new').pos } )
			);
		}
		
		return td;
	}
	
	public static var connection:Expr = macro sys.db.Manager.cnx = sys.db.Mysql.connect( {
		host: $v { Context.definedValue('mysql_host') },
		port: $v { Std.parseInt(Context.definedValue('mysql_port')) }, 
		user: $v { Context.definedValue('mysql_user') }, 
		pass: $v { Context.definedValue('mysql_pass') }, 
		socket: null, 
		database: $v { Context.definedValue('mysql_db') }, 
	} );
	
	private static var EXPRS:StringMap<Expr> = new StringMap<Expr>();
	
	private static function table(cls:ClassType):Expr {
		var result:Expr = null;
		
		if (EXPRS.exists( cls.path() )) {
			result = EXPRS.get( cls.path() );
		} else {
			var cm = Context.parse('${DBConfig.getAltPath(cls)}.manager', cls.pos);
			result = macro if (!sys.db.TableCreate.exists( $cm )) sys.db.TableCreate.create( $cm );
			EXPRS.set( cls.path(), result );
		}
		
		return result;
	}
	
}