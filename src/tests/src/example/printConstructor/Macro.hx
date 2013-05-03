package example.printConstructor;

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
		for (field in Context.getBuildFields()) {
			if (field.name == 'new') {
				trace( new Printer().printField( field ) );
			}
		}
		return Context.getBuildFields();
	}
	
}