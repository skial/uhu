package uhx.macro.jumla.expr;

import haxe.macro.Expr;
import uhx.macro.jumla.a.AFields;

/**
 * ...
 * @author Skial Bainn
 */
class FieldsTools {

	public static inline function sugar(t:Array<Field>):AFields return t;
	
	public static function exists(fields:Array<Field>, name:String):Bool {
		var result:Bool = false;
		
		for (field in fields) if (field.name == name) {
			result = true;
			break;
		}
		
		return result;
	}

	public static function get(fields:Array<Field>, name:String):Field {
		var result:Field = null;
		
		for (field in fields) if (field.name == name) {
			result = field;
			break;
		}
		
		return result;
	}
	
	public static function remove(fields:Array<Field>, name:String):Bool {
		return fields.remove( get( fields, name ) );
	}
	
}