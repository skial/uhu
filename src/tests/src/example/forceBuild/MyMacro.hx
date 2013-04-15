package example.forceBuild;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;

/**
 * ...
 * @author Skial Bainn
 */
class MyMacro
{

	public static function build() {
		trace('MyMacro::build');
		trace('adding @:build metadata');
		Compiler.addMetadata('@:build(example.forceBuild.MyMacro.fragment())', 'example.forceBuild.A');
		trace('getting type');
		var a = Context.getType('example.forceBuild.A');
		trace('follow type to real type');
		a = Context.follow( a );
		trace('done!');
		return Context.getBuildFields();
	}
	
	public static function fragment() {
		trace('MyMacro::fragment');
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		return fields;
	}
	
}