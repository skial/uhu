package uhx.macro.jumla.expr;

import haxe.macro.Expr;

using uhx.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class MetadatasTools {

	public static function get(t:Array<Metadata>, key:String):Metadata {
		return [for (m in t) m.get( key )];
	}
	
	public static function exists(t:Array<Metadata>, key:String):Bool {
		var result:Bool = false;
		for (m in t) if (m.exists( key ) == true) {
			result = true;
			break;
		}
		return result;
	}
	
}