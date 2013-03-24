package example.inline_properties_abstracts;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

/**
 * ...
 * @author Skial Bainn
 */
class BuildMacro {

	public static function mk():Array<Field> {
		var fields = Context.getBuildFields();
		
		var name = 'NewAbstract';
		var int = Context.toComplexType( Context.getType( 'Int' ) );
		var pos = Context.currentPos();
		
		Context.defineType( {
			pack: [],
			name: name,
			pos: pos,
			meta: [],
			params: [],
			isExtern: false,
			kind: TDAbstract( int ),
			fields: [
				{
					name: 'new',
					access: [APublic, AInline],
					kind: FFun( {
						args: [
							{
								name: 'v',
								opt: false,
								type: int
							}
						],
						ret: null,
						expr: macro {
							this = v;
						},
						params:[]
					} ),
					pos: pos
					
				},
				{
					name: 'fromInt',
					access: [APublic, AStatic, AInline],
					kind: FFun( {
						args: [
							{
								name: 'v',
								opt: false,
								type: int
							}
						],
						ret: null,
						expr: macro {
							return new $name( v );
						},
						params: []
					} ),
					pos: pos,
					meta: [ { name:':from', params:[], pos: pos } ]
				},
				{
					name: 'toString',
					access: [APublic, AInline],
					kind: FFun( {
						args: [],
						ret: macro :String,
						expr: macro {
							return '-+-+-';
						},
						params:[]
					} ),
					pos: pos,
					meta: [ { name:':to', params: [], pos: pos } ]
				}
			]
		} );
		
		var new_fields:Array<Field> = [];
		var abstr = Context.toComplexType( Context.getType( name ) );
		
		for (field in fields) {
			
			for (meta in field.meta) {
				
				if (meta.name == ':to') {
					
					var type = null;
					var expr = null;
					
					switch (field.kind) {
						case FVar(t, e):
							type = t;
							expr = e;
						case _:
					}
					
					field.kind = FProp('get', 'never', abstr);
					field.access.remove( AInline );
					
					//new_fields.push( field );
					new_fields.push( {
						name: 'get_${field.name}',
						access: [APrivate, AStatic, AInline],
						kind: FFun( {
							args: [],
							ret: abstr,
							expr: macro {
								return new $name( $expr );
							},
							params:[]
						} ),
						pos: field.pos,
						meta: []
					} );
					
					break;
					
				}
				
			}
			
			new_fields.push( field );
			
		}
		
		return new_fields;
	}
	
}