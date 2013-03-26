package uhu.macro.jumla.type;

import haxe.macro.Type;

/**
 * ...
 * @author Skial Bainn
 */
class ClassFieldTools {

	public static function exists(fields:Array<ClassField>, name:String):Bool {
		var result = false;
		
		for (field in fields) {
			if (field.name == name) {
				result = true;
				break;
			}
		}
		
		return result;
	}
	
	public static function get(fields:Array<ClassField>, name:String):ClassField {
		var result = null;
		
		for (field in fields) {
			if (field.name == name) {
				result = field;
				break;
			}
		}
		
		return result;
	}
	
}