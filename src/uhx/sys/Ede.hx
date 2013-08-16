package uhx.sys;

import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using Lambda;
using StringTools;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 * ede => Help in Haitian Creole 
 */
class Ede {
	
	public static function build():Array<Field> {
		return handler( Context.getLocalClass().get(), Context.getBuildFields() );
	}

	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		if (!fields.exists( 'new' ) == null) {
			throw 'Only class instances are supported';
		}
		
		var _new = fields.get( 'new' );
		
		if (!_new.args().exists( 'args' ))  {
			Context.error( 'Field `new` must have a param named `args` of type `Array<String>`', _new.pos );
		}
		
		// Force the compiler to include javadoc during macro mode.
		Compiler.define( 'use_rtti_doc' );
		
		// Build a lists of instance field names.
		var instances:Array<Expr> = [];
		var typecasts:Array<Expr> = [];
		
		for (field in fields) {
			
			if (!field.access.has( AStatic ) && field.name != 'new') {
				instances.push( macro $v { field.name } );
			}
			
			switch (field.kind) {
				case FVar(t, _), FProp(_, _, t, _):
					var tname = t.toType().getName();
					
					if (tname != 'String') {
						var e = valueCast( tname );
						
						var aliases = [macro $v { field.name } ]
							.concat( field.meta.exists('alias') ? field.meta.get('alias').params : [] );
						
						typecasts.push( 
							macro for (name in [$a { aliases } ]) {
								if (_map.exists( name )) { 
									var v:Dynamic = _map.get( name )[0];
									_map.set(name, [$e]);
								}
							} 
						);
					}
					
				case FFun(_):
					if (field.arity() > 0 && field.name != 'new') {
						
						var arity = 'arity'.mkMeta();
						arity.params.push( macro $v { field.arity() } );
						field.addMeta( arity );
						
						var aliases = [macro $v { field.name } ]
							.concat( field.meta.exists('alias') ? field.meta.get('alias').params : [] );
						
						var argcasts:Array<Expr> = [];
						
						for (i in 0...field.arity()) {
							var tname = field.args()[i].type.toType().getName();
							
							if (tname != 'String') {
								
								argcasts.push( macro var v:Dynamic = _args[$v { i } ] );
								argcasts.push( macro v = $e{valueCast( tname )} );
								
							}
						}
						
						typecasts.push(
							macro for (name in [$a { aliases } ]) {
								if (_map.exists( name )) {
									
									var _args = _map.get( name );
									
									if (_args.length < $v { field.arity() } ) {
										throw '' + (name == $v { field.name } ?$v { '--' + field.name } :'-'+name) + $v { ' expects ' + field.arity() + ' args.' };
									} else {
										$a{argcasts};
									}
									
								}
							}
						);
						
					}
			}
			
		}
		
		// Add commandline methods if they dont exist.
		fields.push( 'help'.mkField().mkPublic()
			.toFFun().body( macro { } )
			.addDoc( 'Show this message.' )
			.addMeta( { name: 'alias', params: [ macro 'h' ], pos: Context.currentPos() } )
		);
		
		instances.push( macro 'help' );
		
		// Get all doc info.
		var checks:Array<{doc:Null<String>, meta:Metadata, name:String}> = [ 
			for (f in fields) 
				if (!f.access.has( AStatic) && f.name != 'new') 
					f 
		];
		checks.unshift( cast cls );
		
		var docs:Array<String> = [];
		
		for (check in checks) {
			
			if (check.doc == null) check.doc = '';
			
			var part = check.doc.replace( '\n', '' ).trim();
			
			if (part == '') {
				if (checks[0] == check) {
					part = check.name;
				}
			}
			
			if (part.startsWith( '*' ) ) part = part.substr( 1 ).trim();
			
			if (checks[0] == check) {
				
				docs.push( part + '\n' );
				
				if (cls.meta.has(':usage')) {
					
					docs.push( '\nUsage:\n' );
					
					for (param in cls.meta.get().get(':usage').params) {
						
						docs.push( '\t' + param.printExpr().replace('"', '') + '\n' );
						
					}
					
				}
				
				docs.push( '\nOptions :\n' );
				
			} else {
				
				var aliases = check.meta.get( 'alias' );
				
				part = '--${check.name}\t$part';
				
				if (aliases != null) for (alias in aliases.params) {
					
					part = '-' + alias.printExpr().replace('"', '') + ', $part';
					
				}
				
				docs.push( '\t$part' + '\n' );
				
			}
			
		}
		
		fields.get( 'help' ).body( macro {
			return $v { docs.join( '' ) };
		} );
		
		var nexprs:Array<Expr> = [];
		
		// Expressions to be put before everything else already in the constructor.
		nexprs.push( macro if (args.length == 0) throw help() );
		nexprs.push( macro var _cmd:uhx.sys.Lod = new uhx.sys.Lod() );
		nexprs.push( macro _cmd.args = args );
		nexprs.push( macro var _map = _cmd.parse() );
		nexprs = nexprs.concat( typecasts );
		nexprs.push( macro var _line:uhx.sys.Liy = new uhx.sys.Liy() );
		nexprs.push( macro _line.obj = this );
		nexprs.push( macro _line.fields = [$a { instances } ] );
		nexprs.push( macro _line.meta = haxe.rtti.Meta.getFields( $i { cls.name } ) );
		nexprs.push( macro _line.args = _map );
		nexprs.push( macro _line.parse() );
		
		var method = _new.getMethod();
		
		switch (method.expr.expr) {
			case EBlock( es ):
				_new.body( { expr: EBlock( nexprs.concat( es ) ), pos: _new.pos } );
				
			case _:
		}
		
		
		return fields;
	}
	
	private static function valueCast(type:String):Expr {
		var result = macro null;
		
		switch ( type ) {
			case 'Int':
				result = macro Std.parseInt( v );
				
			case 'Float':
				result = macro Std.parseFloat( v );
				
			case 'String':
				result = macro v;
		}
		
		return result;
	}
	
}