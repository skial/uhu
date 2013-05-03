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
		trace('Entry Point');
		// @:autoBuild doesnt work
		Compiler.addMetadata('@:build(example.forceBuild.MyMacro.fragment())', 'example.forceBuild.A');
		Compiler.addMetadata('@:build(example.forceBuild.MyMacro.helper())', 'example.forceBuild.A');
		
		var a = Context.getType('example.forceBuild.A');
		a = Context.follow( a );
		
		trace('Lets try it again!');
		Compiler.addMetadata('@:build(example.forceBuild.MyMacro.failer())', 'example.forceBuild.A');
		a = Context.getType('example.forceBuild.A');
		a = Context.follow(a);
		
		return Context.getBuildFields();
	}
	
	public static function fragment() {
		trace('Fragment entry point');
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		return fields;
	}
	
	public static function helper() {
		trace('Helper entry point');
		return Context.getBuildFields();
	}
	
	public static function failer() {
		trace('Failer entry point');
		return Context.getBuildFields();
	}
	
}