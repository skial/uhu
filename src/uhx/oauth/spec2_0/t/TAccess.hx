package uhx.oauth.spec2_0.t;

import uhx.web.URI;

/**
 * ...
 * @author Skial Bainn
 */

typedef TAccess = {
	var auth:URI;
	var access:URI;
	@:optional var callback:URI;
}