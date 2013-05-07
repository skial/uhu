package uhx.macro;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using StringTools;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class Publisher {

	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		
		if (Context.defined('display')) return fields;
		
		var initExprs:Array<Expr> = [];
		
		for (field in fields) {
			
			if (field.name == 'new') continue;
			if (field.meta.exists(':alias_of')) continue;
			
			if (field.meta.exists(':pub')) {
				
				switch (field.kind) {
					case FVar(t, e):
						field.kind = FProp('default', 'set', t, e);
						
						fields.push( createSetter( field, t ) );
						
						if (!fields.exists('UhxSignalFor_${field.name}')) {
							fields.push( createUhxSignalFor( field, t ) );
							initExprs.push( macro $i{'UhxSignalFor_${field.name}'} = new msignal.Signal.Signal1<$t>() );
						}
						
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
			_init = PubSubHelper.create__init__();
			fields.push( _init );
		}
		
		switch (_init.kind) {
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
					$i { 'UhxSignalFor_${field.name}' } .dispatch( v );
					return v;
				}
			} )
		};
	}
	
	private static function createUhxSignalFor(field:Field, ctype:ComplexType):Field {
		return {
			doc: null,
			pos: field.pos,
			access: [APublic, AStatic],
			name: 'UhxSignalFor_${field.name}',
			meta: [],
			kind: FVar(macro :msignal.Signal.Signal1<$ctype>, field.isStatic() ? null : macro new msignal.Signal.Signal1<$ctype>())
		};
	}
	
}