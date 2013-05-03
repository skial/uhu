package example.buildLoop;
import haxe.macro.Compiler;
import haxe.macro.Printer;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class Macro {

	public static function build() {
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		
		//for (i in 0...10) {
			var i = 0;
			var ncls = createMacroClass('' + i);
			
			Context.defineType( ncls );
			var type = Context.getType('MyMacro$i');
			type = Context.follow( type );
			
			Compiler.addMetadata('@:build(MyMacro$i.build())', 'example.buildLoop.B');
			
			var type = Context.getType('example.buildLoop.B');
			type = Context.follow( type );
		//}
		
		return fields;
	}
	
	public static function fragment():Array<Field> {
		trace(Context.getLocalClass().get().name);
		return Context.getBuildFields();
	}
	
	private static function createMacroClass(suffix:String):TypeDefinition {
		return {
			name: 'MyMacro' + suffix,
			pack: [],
			pos: Context.currentPos(),
			meta: [],
			params: [],
			isExtern: false,
			kind: TDClass(),
			fields: [ {
				name: 'build',
				access: [APublic, AStatic],
				kind: FFun( {
					args: [],
					params: [],
					ret: null,
					expr: macro {
						trace('Hello from MyMacro' + $v{suffix});
						return haxe.macro.Context.getBuildFields();
					}
				} ),
				pos: Context.currentPos()
			}]
		}
	}
	
}