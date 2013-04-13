package uhu.macro.jumla.expr;

import haxe.macro.Expr;

/**
 * ...
 * @author Skial Bainn
 */
class MetadataEntryTools {
	
	public static function exists(meta:Array<MetadataEntry>, key:String):Bool {
		var result = false;
		
		for (m in meta) {
			if (m.name == key) {
				result = true;
				break;
			}
		}
		
		return result;
	}
	
	public static function get(meta:Array<MetadataEntry>, key:String):MetadataEntry {
		var result = null;
		
		for (m in meta) {
			if (m.name == key) {
				result = m;
				break;
			}
		}
		
		return result;
	}
	
	public static function remove(meta:Array<MetadataEntry>, key:String):Bool {
		var result = false;
		var target = null;
		
		for (m in meta) {
			if (m.name == key) {
				target = m;
			}
		}
		
		if (target != null) {
			result = meta.remove( target );
		}
		
		return result;
	}
	
}