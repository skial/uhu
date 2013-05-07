package uhx.macro;

import haxe.ds.StringMap;
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
	
	private static var abstractCache:StringMap<Bool> = new StringMap<Bool>();
	
	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		
		
		if (Context.defined( 'display' )) {
			return fields;
		}
		
		for (field in fields) {
			
			if (field.meta.exists(':to')) {
			
				var type = null;
				var expr = null;
				var name = 'AbstractFor_${field.name}';
				var meta = field.meta.get( ':to' );
				
				if (meta == null) continue;
				
				switch (field.kind) {
					case FVar(t, e):
						type = t;
						expr = e;
						
					case FProp(g, s, t, e):
						type = t;
						expr = e;
						
					case FFun(_):
						Context.error('@:to metadata only works on variables. ${cls.path()}::${field.name}', field.pos);
				}
				
				var pack = cls.pack;
				
				var new_type:TypeDefinition = {
					pack: pack,
					name: name,
					pos: cls.pos,
					meta: [],
					params: [],
					isExtern: false,
					kind: TDAbstract( type, [], [type] ),
					fields:	createFields( cls, field, type, expr ),
				}
				
				if (!abstractCache.exists( new_type.path() )) {
					
					abstractCache.set( new_type.path(), true );
					Context.defineType( new_type );
					
				}
				
				var access = [APrivate];
				
				if (field.access.indexOf( AStatic ) != -1) {
					access.push( AStatic );
				}
				
				if (field.access.indexOf( AInline ) != -1) {
					for (i in 0...field.access.length) {
						field.access.remove( AInline);
					}
					access.push( AInline );
				}
				
				// Get newly defined abstract type
				var type = Context.toComplexType( Context.getType( name ) );
				
				switch (field.kind) {
					case FVar(t, _):
						field.kind = FProp('get', 'never', type);
						
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
						
					case FProp(g, s, t, _):
						field.kind = FProp(g, s, type);
						
						var getter = fields.get(g + '_${field.name}');
						
						if (getter != null) {
							
							switch (getter.kind) {
								case FFun(method):
									method.ret = type;
									
								case _:
							}
							
						} else {
							
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
							
						}
						
					case _:
				}
				
				// If field has @:alias metadata, fetch the alias
				// and its getter and modify their types.
				if (field.meta.exists(':alias')) {
					
					var meta = field.meta.get(':alias');
					var value = meta.params[0].printExpr().replace('"', '');
					var _field = fields.get(value);
					
					switch (_field.kind) {
						case FProp(g, s, t, e):
							_field.kind = FProp(g, s, type, e);
							
						case _:
					}
					
					var _get = fields.get('get_${_field.name}');
					
					switch (_get.kind) {
						case FFun(method):
							method.ret = type;
							
						case _:
					}
				}
				
			}
			
		}
		
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