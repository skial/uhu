package uhx.db.macro;

import haxe.crypto.Md5;
import haxe.ds.StringMap;
import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import uhx.macro.KlasImpl;

using StringTools;
using uhu.macro.Jumla;
using Lambda;

/**
 * ...
 * @author Skial Bainn
 */
class DBConfig {
	
	public static var DATABASES:StringMap< {handler:ClassType->Array<Field>->?Bool->Array<Field>, connection:Expr, table:ClassType->Expr } > = cast [
		'mysql' => MySQLConfig,
		//'tokudb' => '',
	];
	
	public static var CACHES:StringMap<String> = [
		'redis' => '',
		'memcached' => '',
	];
	
	private static var BUILT:Array<String> = [];
	
	private static var Init:Array<Expr> = [];
	
	private static var DB:TypeDefinition = { name: 'DB' + Md5.encode(Date.now().toString()), pack: ['uhx'], kind: TDClass(), 
		fields: [ ], params: [], pos: Context.currentPos(), 
		meta: [ { name: ':native', params: [macro $v { 'uhx.DB' } ], pos: Context.currentPos() }, ':keep'.mkMeta() ], isExtern: false, 
	};
	
	private static var PreviousDB:String = 'uhx.DB';
	
	public static function build() {
		return handler( Context.getLocalClass().get(), Context.getBuildFields() );
	}
	
	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		var db:String = null;
		var cache:String = null;
		
		if (!Context.defined( 'display' )) {
			
			var db = null;
			var expr = null;
			var meta = getMeta( cls );
			
			if (meta == null) {
				
				var _cls = cls;
				
				while (true) {
					if (_cls.superClass != null) {
						
						_cls = _cls.superClass.t.get();
						meta = getMeta( _cls );
						
						if (_cls.superClass == null && meta != null && DATABASES.exists( meta.db )) {
							
							db = DATABASES.get( meta.db );
							expr = db.table( _cls );
							if (Init.indexOf( expr ) == -1 ) Init.push( expr );
							
						}
						
					} else {
						break;
					}
				}
				
				if (meta == null) {
					Context.warning( '${cls.path()} does not have or inherit from a class that has @:db(database, cache) metadata', cls.pos );
				}
				
			} else {
				db = DATABASES.get( meta.db );
			}
			
			fields = db.handler( cls, fields );
			
			if (Init.indexOf( db.connection ) == -1) {
				Init.unshift( db.connection );
			}
			
			expr = db.table( cls );
			if (Init.indexOf( expr ) == -1 ) Init.push( expr );
			
			BUILT.push( cls.path() );
			
			// Destroy uhx.DB and recreate it
			if (PreviousDB != null) {
				DB.name = 'DB' + Md5.encode(PreviousDB + Date.now().toString());
			}
			
			// Modifying the field results in the field not being generated.
			// Moving from `DB` and setting each time its needed works.
			DB.fields = [ 
				'start'.mkField().mkPublic()
				.mkStatic().toFFun().addMeta(':keep'.mkMeta())
				.body( { expr:EBlock( Init ), pos: DB.pos } )
			];
			
			Context.defineType( DB );
			Compiler.exclude( PreviousDB );
			PreviousDB = DB.path();
			trace( DB.printTypeDefinition() );
			
		}
		
		if (cls.meta.has(':db')) {
			// This make's it look like these fields exists and to stop the compiler from croaking.
			for (f in ['insert', 'update', 'delete', 'lock', 'unlock']) {
				var _f = f.mkField().mkPublic().toFFun().body( macro { trace(''); } ).ret(macro:Void);
				fields.push( _f );
			}
		}
		
		return fields;
	}
	
	private static function getMeta(cls:ClassType): { db:String, cache:String } {
		var result = { db:'', cache:'' };
		
		if (cls.meta.has(':db')) {
			var m = cls.meta.get().get(':db');
			result.db = m.params[0].printExpr().toLowerCase();
			result.cache = m.params[1].printExpr().toLowerCase();
		} else {
			result = null;
		}
		
		return result;
	}
	
	private static var RENAMED:StringMap<String> = new StringMap<String>();
	
	public static function getAltPath(base:BaseType):String {
		var result = '';
		
		if (RENAMED.exists( base.path() )) {
			
			result = RENAMED.get( base.path() );
			
		} else {
			
			var name = base.name + Md5.encode('mysqlmacro' + Date.now().toString());
			RENAMED.set( base.name, name );
			
			var path = base.path().replace( '.' + base.name, '.' + name );
			RENAMED.set( base.path(), path );
			
			result = path;
			
		}
		
		return result;
	}
	
	public static function getAltName(base:BaseType):String {
		var result = '';
		
		if (RENAMED.exists( base.name )) {
			
			result = RENAMED.get( base.name );
			
		} else {
			
			var name = base.name + Md5.encode('mysqlmacro' + Date.now().toString());
			RENAMED.set( base.name, name );
			
			var path = base.path().replace( '.' + base.name, '.' + name );
			RENAMED.set( base.path(), path );
			
			result = name;
			
		}
		
		return result;
	}
	
}