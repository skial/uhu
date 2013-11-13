package uhx.macro.jumla.expr;

import haxe.macro.Expr;

/**
 * ...
 * @author Skial Bainn
 */
class MetadataTools {

	public static function get(t:Metadata, key:String):MetadataEntry {
		var result:MetadataEntry = null;
		
		for (m in t) if (m.name == key) {
			result = m;
			break;
		}
		
		return result;
	}
	
	public static function exists(t:Metadata, key:String):Bool {
		var result:Bool = false;
		
		for (m in t) if (m.name == key) {
			result = true;
			break;
		}
		
		return result;
	}
	
}