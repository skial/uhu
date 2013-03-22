package uhx.macro;

import haxe.macro.ComplexTypeTools;
import haxe.macro.Printer;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.TypeTools;

using Lambda;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */

class ToType {
	
	public static var META:Array<String> = [':toInt', ':toString'];
	
	public static function handler(cls:ClassType, field:Field):Field {
		var type = null;
		var expr = null;
		var name = '';
		
		if (!field.meta.exists(':processed_by')) {
			
			name = 'AbstractFor_${field.name}';
			
			switch (field.kind) {
				case FVar(t, e) | FProp(_, _, t, e):
					type = t;
					expr = e;
					
				case FFun(_):
					Context.warning('@:to<Type> metadata only works on variables.', field.pos);
			}
			
			var new_type:TypeDefinition = {
				pack: cls.pack,
				name: name,
				pos: cls.pos,
				meta: [],
				params: [],
				isExtern: false,
				kind: TDAbstract( type, [type] ),
				fields:	createFields( cls, field, type, expr ),
			}
			/*var p = new Printer();
			trace( p.printTypeDefinition( new_type ) );
			*/
			Context.defineType( new_type );
			
			if (field.access.indexOf( AInline ) != -1) {
				field.access.remove( AInline );
				field.meta.push( { name:':extern', params:[], pos:field.pos } );
			}
			//new_type.meta.push( { name:':coreType', params: [], pos:new_type.pos } );
			//new_type.meta.push( { name:':runtimeValue', params: [], pos:new_type.pos } );
			
			//field.meta.push( { name:':extern', params: [], pos:field.pos } );
			field.meta.push( { name:':processed_by', params: [ macro 'uhx.macro.ToType' ], pos:field.pos } );
			
			type = Context.toComplexType( Context.getType( name ) );
			
			switch (field.kind) {
				case FVar(_, e):
					
					//e = macro { function() { return new $name( $e ); }() };
					e = macro { new $name( $e ); };
					field.kind = FVar( type, e );
					
				case FProp(s, g, _, e):
					
					//e = macro { function() { return new $name( $e ); }() };
					e = macro { new $name( $e ); };
					field.kind = FProp(s, g, type, e );
					
				case FFun(_):
					
					Context.error('How the hell did it progress this far?!?!?!. Open a new issue at http://github.com/skial/uhu/issues with an example please!', field.pos);
					
			}
			
		}
		
		return field;
	}
	
	public static function createFields(cls:ClassType, field:Field, type:ComplexType, expr:Expr):Array<Field> {
		var result:Array<Field> = [];
		var to_field:Field = null;
		var name = 'AbstractFor_${field.name}';
		
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
		
		for (meta in field.meta) {
			
			var value = meta.params[0];
			
			switch (meta.name) {
				case ':toInt':
					to_field = {
						name: 'toInt',
						access: [APublic, AInline],
						kind: FFun( {
							args: [],
							ret: macro :Int,
							expr: macro {
								return $value;
							},
							params:[]
						} ),
						pos: field.pos,
						meta: [ { name:':to', params: [], pos: field.pos } ]
					}
					
				case ':toString':
					
					if (value == null) {
						value = macro $v { field.name };
					}
					
					to_field = {
						name: 'toString',
						access: [APublic, AInline],
						kind: FFun( {
							args: [],
							ret: macro :String,
							expr: macro {
								return $value;
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