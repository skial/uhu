package uhx.macro;

import haxe.macro.ComplexTypeTools;
import haxe.macro.Printer;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.TypeTools;

using Lambda;
using StringTools;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */

class To {
	
	public static function handler(cls:ClassType, field:Field):Array<Field> {
		var fields:Array<Field> = [];
		
		if (Context.defined( 'display' )) {
			return [ field ];
		}
		
		var type = null;
		var expr = null;
		var name = 'AbstractFor_${field.name}';
		var meta = field.meta.get( ':to' );
		
		switch (field.kind) {
			case FVar(t, e):
				type = t;
				expr = e;
				
			case FProp(_, _, _, _):
				Context.error('@:to metadata only works on variables without getters or setters.', field.pos);
				
			case FFun(_):
				Context.error('@:to metadata only works on variables.', field.pos);
		}
		
		var pack = cls.pack;
		
		var new_type:TypeDefinition = {
			pack: pack,
			name: name,
			pos: cls.pos,
			meta: [],
			params: [],
			isExtern: false,
			kind: TDAbstract( type ),
			fields:	createFields( cls, field, type, expr ),
		}
		
		Context.defineType( new_type );
		
		var access = [APrivate];
		
		if (access.indexOf( AStatic ) == -1) {
			access.push( AStatic );
		}
		
		if (field.access.indexOf( AInline ) != -1) {
			field.access.remove( AInline );
			access.push( AInline );
		}
		
		var type = Context.toComplexType( Context.getType( name ) );
		field.kind = FProp('get', 'never', type);
		//field.meta = [];
		
		fields.push( field );
		
		fields.push( {
			name: 'get_${field.name}',
			access: access,
			kind: FFun( {
				args: [],
				ret: type,
				expr: macro {
					return new $name( $expr );
				},
				params:[]
			} ),
			pos: field.pos,
			meta: []
		} );
		
		return fields;
	}
	
	public static function createFields(cls:ClassType, field:Field, type:ComplexType, expr:Expr):Array<Field> {
		var result:Array<Field> = [];
		var to_field:Field = null;
		var name = 'AbstractFor_${field.name}';
		var meta = field.meta.get( ':to' );
		
		result.push( {
			name: 'new',
			access: [APublic, AInline],
			kind: FFun( {
				args: [
					{
						name: 'v',
						opt: false,
						type: type
					}
				],
				ret: null,
				expr: macro {
					this = v;
				},
				params:[]
			} ),
			pos: field.pos
		} );
		
		result.push( {
			name: 'from' + type.toString(),
			access: [APublic, AStatic, AInline],
			kind: FFun( {
				args: [
					{
						name: 'v',
						opt: false,
						type: type
					}
				],
				ret: null,
				expr: macro {
					return new $name( v );
				},
				params: []
			} ),
			pos: field.pos,
			meta: [ { name:':from', params:[], pos:field.pos } ]
		} );
		
		for (param in meta.params) {
			
			var id = param.toString();
			var value = null;
			
			if (id.indexOf('=') == -1) {
				value = field.name;
			} else {
				value = id.split('=')[1].replace('"', '');
			}
			
			switch (id.charAt(0)) {
				case 's':
					to_field = {
						name: 'toString',
						access: [APublic, AInline],
						kind: FFun( {
							args: [],
							ret: macro :String,
							expr: macro {
								return $v{value};
							},
							params:[]
						} ),
						pos: field.pos,
						meta: [ { name:':to', params: [], pos: field.pos } ]
					}
					
				case 'i':
					to_field = {
						name: 'toInt',
						access: [APublic, AInline],
						kind: FFun( {
							args: [],
							ret: macro :Int,
							expr: macro {
								return $v{Std.parseInt(value)};
							},
							params:[]
						} ),
						pos: field.pos,
						meta: [ { name:':to', params: [], pos: field.pos } ]
					}
					
				case _:
					
			}
			
			if (to_field != null) {
				result.push( to_field );
			}
			
			to_field = null;
			
		}
		
		return result;
	}
	
}