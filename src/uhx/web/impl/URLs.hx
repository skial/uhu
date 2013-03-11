package uhx.web.impl;

#if neko
import neko.Web in Web;
#elseif php
import php.Web in Web;
#end

import uhx.web.URI;

using uhx.web.URLs;

/**
 * @author Skial Bainn
 */

class URLs {
	
	public static var location(get, null):URI;
	
	private static function get_location():URI {
		var current = Web.getHostName() + Web.getURI();
		return current.toURL();
	}

	public static inline function toURL(value:String):URI {
		return new URI(value);
	}
	
}