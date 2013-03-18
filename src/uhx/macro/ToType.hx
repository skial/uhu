package uhx.macro;

import haxe.macro.Type;
import haxe.macro.Expr;

/**
 * ...
 * @author Skial Bainn
 */

class ToType {
	
	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		return fields;
	}
	
}