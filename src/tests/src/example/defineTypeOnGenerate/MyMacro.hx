package example.defineTypeOnGenerate;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;

/**
 * ...
 * @author Skial Bainn
 */
class MyMacro {

	public static function build() {
		Context.onGenerate( onGenerate );
		
		return Context.getBuildFields();
	}
	
	public static function onGenerate(types:Array<Type>) {
		
		var new_type:TypeDefinition = {
			pack: [],
			name: 'AFoo',
			pos: Context.currentPos(),
			meta: [ { name:':keep', params:[], pos:Context.currentPos() } ],
			params: [],
			isExtern: false,
			kind: TDClass(),
			fields: [ {
				name: 'something',
				access: [APublic],
				kind: FFun( {
					args: [],
					ret: null,
					expr: macro {
						trace('Hello Universe');
					},
					params: []
				} ),
				pos: Context.currentPos(),
				meta: [],
			} ]
		}
		
		Context.defineType( new_type );
		trace( Context.getType( 'AFoo' ) );
	}
	
}