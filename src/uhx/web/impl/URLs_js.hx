package uhx.web.impl;

import uhx.web.URI;

using uhx.web.ParamParser;

/**
 * ...
 * @author Skial Bainn
 */
class URLs_js {
	
	public static var location(get, null):URI;
	
	private static function get_location():URI {
		var current = js.Browser.window.location;
		var result = new URI( '' );
		
		result.scheme = current.protocol;
		result.hostname = current.hostname;
		result.port = current.port;
		result.path = current.pathname;
		result.fragment = current.hash;
		
		result.query = current.search.parseParams();
		
		return result;
	}

	public static inline function toURL(value:String):URI {
		return new URI(value);
	}
	
}