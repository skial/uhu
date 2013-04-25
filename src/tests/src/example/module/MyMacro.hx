package example.module;

import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class MyMacro {

	public static function build() {
		var old_cls = Context.getLocalClass().get();
		var old_ctype = Context.toComplexType( Context.getLocalType() );
		trace( old_ctype );
		
		trace( Context.getType('example.module.B') );
		trace( Context.getModule('example.module.A') );
		
		var new_cls:TypeDefinition = {
			pack: ['example', 'module'],
			name: 'A.NewTypes',
			pos: old_cls.pos,
			meta: [],
			params: [],
			isExtern: false,
			kind: TDClass( null, [], false ),
			fields: [ {
				name: 'hello',
				access: [APublic, AStatic],
				kind: FFun( {
					args: [],
					ret: null,
					expr: macro {
						trace('Hello Universe from NewType');
					},
					params: []
				} ),
				pos: Context.getBuildFields()[0].pos,
				meta: []
			} ]
		}
		
		Context.defineType( new_cls );
		
		trace( Context.getModule('example.module.A') );
		
		return Context.getBuildFields();
	}
	
}