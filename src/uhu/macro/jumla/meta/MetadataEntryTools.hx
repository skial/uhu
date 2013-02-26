package uhu.macro.jumla.meta;

import haxe.macro.Expr;

/**
 * ...
 * @author Skial Bainn
 */
class MetadataEntryTools {
	
	public static function exists(meta:Array<MetadataEntry>, name:String):Bool {
		var result = false;
		
		for (m in meta) {
			if (m.name == name) {
				result = true;
				break;
			}
		}
		
		return result;
	}
	
}