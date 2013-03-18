package uhx.macro;

import haxe.macro.Type;
import haxe.macro.Expr;

/**
 * ...
 * @author Skial Bainn
 */

class Alias {

	public static function handler(cls:ClassType, field:Field):Field {
		return field;
	}
	
}