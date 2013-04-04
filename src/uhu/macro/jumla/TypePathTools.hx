package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.t.TComplexString;

/**
 * @author Skial Bainn
 */

class TypePathTools {
	
	public static function clean(t:TypePath):TypePath {
		return t;
	}
	
	@:extern public static inline function toString(t:TypePath):String {
		return Printer.printTypePath( t );
	}
	
	public static function toComplexString(t:TypePath):TComplexString {
		var result = { name:t.pack.join( '.' ) + (t.pack.length > 0 ? '.' : '') + t.name, params:[] };
		
		for (i in t.params) {
			result.params.push( TypeParamTools.toComplexString( i ) );
		}
		
		return result;
	}
	
}