package uhx.oauth.spec2_0.i;

import haxe.Http;
import uhx.http.Method;
import uhx.util.URLParser;

/**
 * @author Skial Bainn
 */

interface IRequest {
	
	public var http:Http;
	
	// The url to send everything to.
	public var endpoint(default, set):URLParser;
	
	public var method:Methods;
	
}