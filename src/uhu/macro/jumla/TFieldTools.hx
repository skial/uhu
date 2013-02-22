package uhu.macro.jumla;

import uhu.macro.jumla.t.TField;

using Lambda;

/**
 * @author Skial Bainn
 */

class TFieldTools {
	
	public static function exists(fields:Array<TField>, name:String):Bool {
		var result = fields.exists( function(field):Bool {
			return (field.name == name) ? true : false;
		} );
		
		return result;
	}
	
	public static function get(fields:Array<TField>, name:String):TField {
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