package uhu.macro.jumla.expr;

import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class MetadataEntryTools {
	
	public static function mkMeta(n:String):MetadataEntry {
		return {
			name: n,
			params: [],
			pos: Context.currentPos(),
		}
	}
	
}