package uhx.macro;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import uhx.macro.jumla.a.Reference;
import uhx.macro.jumla.a.References;

/**
 * ...
 * @author Skial Bainn
 */
class Test {

	public static function handler(c:ClassType, fields:References<Field>):Array<Field> {
		for (field in fields) {
			trace( field );
		}
		return fields;
	}
	
}