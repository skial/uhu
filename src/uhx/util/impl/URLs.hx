package uhx.util.impl;

import uhx.util.URLParser;

/**
 * @author Skial Bainn
 */

class URLs {

	public static inline function asURL(value:String):URLParser {
		return new URLParser(value);
	}
	
}