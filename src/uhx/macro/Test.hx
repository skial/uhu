package uhx.macro;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import uhx.macro.jumla.a.Klass;
import uhx.macro.jumla.a.Reference;
import uhx.macro.jumla.a.References;

import uhx.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class Test {

	public static function handler(c:ClassType, f:Array<Field>):Array<Field> {
		var cls:Klass = c;
		var fields:References = f;
		return fields;
	}
	
}