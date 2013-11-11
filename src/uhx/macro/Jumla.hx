package uhx.macro;

import haxe.macro.Expr;
import haxe.macro.Type;
import uhx.macro.jumla.e.State;

/**
 * ...
 * @author Skial Bainn
 */
class Jumla {
	
	public static var STATE:State = Expression;

	public function new() {
		
	}
	
	/**
	 * Return value of 0 == haxe.macro.Expr.Field
	 * Return value of 1 == haxe.macro.Type.ClassField;
	 * Return value of -1 is neither.
	 */
	public static function fieldType(v:Dynamic):Int {
		var result = -1;
		
		if (Reflect.hasField(v, 'kind')) {
			
			var f = Reflect.field(v, 'kind');
			
			if (Std.is(f, FieldType)) {
				result = 0;
			} else if (Std.is(f, FieldKind)) {
				result = 1;
			}
			
		}
		
		return result;
	}
	
}