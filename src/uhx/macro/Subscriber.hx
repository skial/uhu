package uhx.macro;

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

	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		
		if (Context.defined('display')) return fields;
		
		var newExprs:Array<Expr> = [];
		var initExprs:Array<Expr> = [];
		
		for (field in fields) {
			
			if (field.name == 'new') continue;
			if (field.meta.exists(':alias_of')) continue;
			
			if (field.meta.exists(':sub')) {
				
				var meta = field.meta.get(':sub');
				
				if (meta == null) continue;
				
				if (meta.params.length > 0) {
					
					var value = meta.params[0].printExpr().replace('"', '');
					var parts = value.split('.');
					var fname = parts[parts.length-1];
					var isStatic = (fname.indexOf('::') == -1);
					
					if (!isStatic) {
						
						var bits = parts.pop().split('::');
						parts.push( bits.shift() );
						fname = bits[0];
						
					} else {
						
						fname = parts.pop();
						
					}
					
					// Check the target class and field
					// to see if it implements Klas and
					// the field has @:pub metadata.
					// DISABLED AS SOME TYPES CANT BE FORCE TYPED
					// SO THE WARNINGS AND CHECKS ARE POINTLESS
					/*var pubType = parts.join('.').getType().follow();
					
					switch( pubType ) {
						case TInst(t, _):
							var _cls = t.get();
							var _field = isStatic ? _cls.statics.get().get(fname) : _cls.fields.get().get(fname);
							
							if (_field == null) {
								trace('${_cls.path()}::$fname does not seem to exist.');
								Context.warning('${_cls.path()}::$fname does not seem to exist.', _cls.pos);
								continue;
							}
							
							if (!_cls.hasInterface( 'Klas' )) {
								trace('${_cls.path()} does not implement Klas, unfortuantly this is required.');
								Context.warning('${_cls.path()} does not implement Klas, unfortuantly this is required.', _cls.pos);
								continue;
							}
							
							if (!_field.meta.has( ':pub' )) {
								trace('${_cls.path()}::${_field.name} does not have @:pub metadata.');
								Context.warning('${_cls.path()}::${_field.name} does not have @:pub metadata.', _field.pos);
								continue;
							}
							
						case _:
					}*/
					
					// Now modify the field
					switch (field.kind) {
						case FVar(t, e):
							field.kind = FProp('default', 'set', t, e);
							
							fields.push( createSetter( field, t ) );
							
						case FProp(g, s, t, e):
							var set = fields.get(s + '_${field.name}');
							
							field.kind = FProp(g, set == null ? 'set' : s, t, e);
							
							if (set == null) {
								fields.push( createSetter( field, t ) );
							}
							
						case _:
					}
					
					var _arr = isStatic ? initExprs : newExprs;
					_arr.push( Context.parse('${parts.join(".")}.UhxSignalFor_$fname.add(set_${field.name})', field.pos) );
					
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
	
	private static function createSetter(field:Field, ctype:ComplexType):Field {
		return {
			doc: null,
			pos: field.pos,
			access: field.access,
			name: 'set_${field.name}',
			meta: [],
			kind: FFun( {
				ret: ctype,
				args: [
					{
						name: 'v',
						opt: false,
						type: ctype
					}
				],
				params: [],
				expr: macro {
					$i { field.name } = v;
					return v;
				}
			} )
		};
	}
	
}