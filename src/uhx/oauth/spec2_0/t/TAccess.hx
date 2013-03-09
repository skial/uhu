package uhx.oauth.spec2_0.t;

import uhx.util.URLParser;

/**
 * ...
 * @author Skial Bainn
 */

typedef TAccess = {
	var auth:URLParser;
	var access:URLParser;
	@:optional var callback:URLParser;
}