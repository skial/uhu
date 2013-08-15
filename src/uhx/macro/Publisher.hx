package uhx.macro;

import haxe.ds.StringMap;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using StringTools;
using uhu.macro.Jumla;
using haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class Publisher {
	
	private static var pubCache:StringMap<Bool> = new StringMap<Bool>();

	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		
		if ('display'.defined()) return fields;
		
		var initExprs:Array<Expr> = [];
		
		for (field in fields) {
			
			if (field.meta.exists(':pub')) {
				
				switch (field.kind) {
					case FVar(t, e):
						
						field.kind = FProp('default', 'set', t, e);
						
						//var ns = [''];
						var params = field.meta.get(':pub').params;
						var es = [macro $i { field.name } = v];
						var fs = [];
						
						// This is needed to force the default signal to be created as well.
						// DCE should remove it if unused. Needs testing.
						params.push( macro ns='' );
						
						for (param in params) {
							var ns = param.printExpr().split('ns=')[1].replace('"', '');
							
							if (ns != '') ns = 'NS$ns';
							var fname = 'UhxSignalFor_$ns${field.name}';
							
							es.push( macro $i { fname } .trigger( v ) );
							fs.push( fname );
							
							if (!pubCache.exists( fname )) {
								
								//initExprs.push( macro $i { fname } = new msignal.Signal.Signal1<$t>() );
								initExprs.push( macro $i { fname } = new thx.react.Signal.Signal1<$t>() );
								pubCache.set( fname, true );
								
							}
						}
						
						es.push( macro return v );
						
						for (f in fs) {
							
							if (!fields.exists( f )) {
								
								fields.push( {
									name: f,
									meta: [],
									doc: null,
									pos: field.pos,
									access: [APublic, AStatic],
									//kind: FVar(macro :msignal.Signal.Signal1<$ctype>, null)
									kind: FVar(macro :thx.react.Signal.Signal1<$t>, null)
								} );
								
							}
							
						}
						
						fields.push( field._setter( { expr: EBlock( es ), pos: field.pos } ) );
						
						/*var fname = 'UhxSignalFor_${field.name}';
						
						fields.push( field._setter( macro {
							$i { field.name } = v;
							//$i { fname } .dispatch( v );
							$i { fname } .trigger( v );
							return v;
						} ) );
						
						if (!fields.exists( fname )) {
							
							fields.push( createUhxSignalFor( field, t ) );
							
						}
						
						if (!pubCache.exists( fname )) {
							
							//initExprs.push( macro $i { fname } = new msignal.Signal.Signal1<$t>() );
							initExprs.push( macro $i { fname } = new thx.react.Signal.Signal1<$t>() );
							pubCache.set( fname, true );
							
						}*/
						
					case FProp(g, s, t, e):
						trace(field.name);
						
					case _:
				}
				
			}
			
		}
		
		var _init = fields.get('__init__');
		
		// If _init is null create an __init__ field.
		if (_init == null) {
			// no `__init__` method was found, make it!
			_init = PubSubHelper._init();
			fields.push( _init );
		}
		
		switch (_init.kind) {
			case FFun(method):
				method.ret = null;
				
				switch (method.expr.expr) {
					case EBlock(es):
						method.expr = { expr: EBlock( es.concat( initExprs ) ), pos: _init.pos };
						
					case _:
				}
				
			case _:
		}
		
		return fields;
	}
	
	private static function createUhxSignalFor(field:Field, ctype:ComplexType):Field {
		return {
			doc: null,
			pos: field.pos,
			access: [APublic, AStatic],
			name: 'UhxSignalFor_${field.name}',
			meta: [],
			//kind: FVar(macro :msignal.Signal.Signal1<$ctype>, null)
			kind: FVar(macro :thx.react.Signal.Signal1<$ctype>, null)
		};
	}
	
}