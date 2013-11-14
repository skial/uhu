package uhx.macro.jumla.expr;

import haxe.macro.Expr;
import uhx.macro.jumla.a.AAccess;

using Lambda;

/**
 * ...
 * @author Skial Bainn
 */
class AccessTools {

	public static function sugar(t:Array<Access>):AAccess return t;
	
	public static function exists(t:Array<Access>, value:Access):Bool {
		return t.indexOf( value ) > -1;
	}
	
}