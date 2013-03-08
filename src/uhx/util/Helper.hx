package uhx.util;

using Lambda;
using StringTools;
using de.polygonal.core.fmt.ASCII;

/**
 * ...
 * @author Skial Bainn
 */

class Helper {
	
	public static var RESERVED = ['-', '.', '_', '~'];

	public static function escape(src:String):String {
		var result = '';
		var current = 0;
		
		#if !js
		for (i in 0...src.length) {
			current = src.charCodeAt(i);
			
			if ( current.isASCII() && ( current.isAlphaNumeric() || RESERVED.indexOf(src.charAt(i)) != -1 ) ) {
				result += src.charAt(i);
			} else {
				result += '%' + current.hex();
			}
		}
		#else
		// from https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/encodeURIComponent
		// explains http://stackoverflow.com/a/3608791
		result = untyped __js__("encodeURIComponent(src).replace(/[!'()]/g, escape).replace(/\\*/g, '%2A')");
		#end
		
		return result;
	}
	
	// correct naming?
	public static function toArray(r:EReg, value:String):Array<String> {
		var result = [];
		
		r.map(value, function(r) {
			var b = true;
			var i = 1;
			
			while (b == true) {
				try {
					result.push( r.matched(i) );
				} catch (e:Dynamic) {
					b = false;
				}
				
				i++;
			}
			
			return '';
		} );
		
		return result;
	}
	
}