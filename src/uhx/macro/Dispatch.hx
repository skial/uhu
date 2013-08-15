package uhx.macro;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class Dispatch {
	
	public static function build():Array<Field> {
		return handler( Context.getLocalClass().get(), Context.getBuildFields() );
	}

	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		
		/*
		 * `cls` must have a static `run` method.
		 * 		- if it exists, move everything out of `run` into a new method.
		 * 		- if its missing, create it.
		 * 		- the `run` method *should* return something, which will be passed to `Std.string`.
		 * 
		 * 	`/example/page/10`
		 * 	function example(arg1:String, arg2:Int) {}
		 * 	arg1 = 'page'
		 * 	arg2 = Std.parseInt( '10' )
		 */
		
		return fields;
	}
	
}