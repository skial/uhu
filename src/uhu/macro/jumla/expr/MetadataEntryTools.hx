package uhu.macro.jumla.expr;

import haxe.macro.Expr;

/**
 * ...
 * @author Skial Bainn
 */
class MetadataEntryTools {
	
	public static function exists(meta:Array<MetadataEntry>, key:String):Bool {
		var result = false;
		
		if (meta != null && meta.length > 0) {
			for (m in meta) {
				if (m.name == key) {
					result = true;
					break;
				}
			}
		}
		
		return result;
	}
	
	public static function get(meta:Array<MetadataEntry>, key:String):MetadataEntry {
		var result = null;
		
		if (meta != null && meta.length > 0) {
			for (m in meta) {
				if (m.name == key) {
					result = m;
					break;
				}
			}
		}
		
		return result;
	}
	
	public static function remove(meta:Array<MetadataEntry>, key:String):Bool {
		var result = false;
		var target = null;
		
		if (meta != null && meta.length > 0) {
			for (m in meta) {
				if (m.name == key) {
					target = m;
				}
			}
		}
		
		if (target != null) {
			result = meta.remove( target );
		}
		
		return result;
	}
	
}