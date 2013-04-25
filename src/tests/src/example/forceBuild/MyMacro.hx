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
		// @:autoBuild doesnt work
		Compiler.addMetadata('@:build(example.forceBuild.MyMacro.fragment())', 'example.forceBuild.A');
		Compiler.addMetadata('@:build(example.forceBuild.MyMacro.helper())', 'example.forceBuild.A');
		trace('getting type');
		var a = Context.getType('example.forceBuild.A');
		trace('follow type to real type');
		a = Context.follow( a );
		trace('done!');
		
		trace('Lets try it again!');
		trace('Adding @:build metadata');
		Compiler.addMetadata('@:build(example.forceBuild.MyMacro.failer())', 'example.forceBuild.A');
		trace('Getting type again');
		a = Context.getType('example.forceBuild.A');
		trace('Follow type');
		a = Context.follow(a);
		trace('Done! Should have failed adding third @:build');
		return Context.getBuildFields();
	}
	
	public static function fragment() {
		trace('MyMacro::fragment');
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		return fields;
	}
	
	public static function helper() {
		trace('MyMacro::helper');
		return Context.getBuildFields();
	}
	
	public static function failer() {
		trace('MyMacro::failer');
		return Context.getBuildFields();
	}
	
}