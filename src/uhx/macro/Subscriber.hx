package uhx.macro;

import haxe.ds.StringMap;
import haxe.macro.Compiler;
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
class Subscriber {
	
	private static var subCache:StringMap<Bool> = new StringMap<Bool>();

	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		
		if ('display'.defined()) return fields;
		
		var newExprs:Array<Expr> = [];
		var initExprs:Array<Expr> = [];
		
		for (field in fields) {
			
			if (field.name == 'new') continue;
			if (field.meta.exists(':alias_of')) continue;
			
			if (field.meta.exists(':sub')) {
				
				for (meta in field.meta.getAll(':sub')) {
					
					if (meta.params.length > 0) {
						
						// Break apart the string
						var value = meta.params[0].printExpr().replace('"', '');
						var parts = value.split('.');
						var fname = parts[parts.length - 1];
						// Determine if the field is static
						var isStatic = (fname.indexOf('::') == -1);
						
						if (!isStatic) {
							
							var bits = parts.pop().split('::');
							parts.push( bits.shift() );
							fname = bits[0];
							
						} else {
							
							fname = parts.pop();
							
						}
						
						// Now modify the field
						switch (field.kind) {
							case FVar(t, e):
								field.kind = FProp('default', 'set', t, e);
								
								fields.push( field._setter( macro {
									$i { field.name } = v;
									return v;
								} ) );
								
							case FProp(g, s, t, e):
								var set = fields.get(s + '_${field.name}');
								
								field.kind = FProp(g, set == null ? 'set' : s, t, e);
								
								if (set == null) {
									fields.push( field._setter( macro {
										$i { field.name } = v;
										return v;
									} ) );
								}
								
							case _:
						}
						
						var key = '${parts.join(".")}.UhxSignalFor_$fname.add(set_${field.name})';
						if (!subCache.exists( key )) {
							
							var _arr = field.isStatic() ? initExprs : newExprs;
							_arr.push( key.parse( field.pos ) );
							
							subCache.set( key, true );
							
						}
						
					}
					
				}
				
			}
			
		}
		
		var _new = fields.get('new');
		var _init = fields.get('__init__');
		
		// If _init is null create an __init__ field.
		if (_init == null) {
			// no `__init__` method was found, make it!
			_init = PubSubHelper.create__init__();
			fields.push( _init );
		}
		
		// If _new is null, then assume its a
		// static class and has an __init__ field
		if (_new == null) _new = _init;
		
		// Add newExprs contents to _new
		switch ( _new.kind ) {
			case FFun(method):
				method.ret = null;
				
				for (e in newExprs) {
					method.expr = e.concat( method.expr );
				}
				
			case _:
		}
		
		// Add initExprs contents to _init
		switch ( _init.kind ) {
			case FFun(method):
				method.ret = null;
				
				for (e in initExprs) {
					method.expr = e.concat( method.expr );
				}
				
			case _:
		}
		
		return fields;
	}
	
}