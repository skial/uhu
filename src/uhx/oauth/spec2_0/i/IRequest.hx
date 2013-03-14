package uhx.oauth.spec2_0.i;

import haxe.Http;
import uhx.web.URI;
import haxe.ds.StringMap;
import uhx.oauth.spec2_0.e.EGrant;

/**
 * @author Skial Bainn
 */

interface IRequest {
	
	// The prepared http object.
	public var http(get, null):Http;
	public function get_http():Http;
	
	// The url to send everything to.
	public var url:URI;
	
}