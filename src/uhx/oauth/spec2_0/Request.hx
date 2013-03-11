package uhx.oauth.spec2_0;

import haxe.Http;
import haxe.ds.StringMap;
import uhx.web.URI;
import uhx.oauth.spec2_0.e.EGrant;
import uhx.oauth.spec2_0.i.IRequest;

/**
 * ...
 * @author Skial Bainn
 */
class Request implements IRequest {
	
	@:isVar public var http(get, null):Http;
	public var url:URI;

	public function new() {
		
	}
	
	public function get_http():Http {
		if (http == null) {
			http = new Http( url.toString() );
		}
		return http;
	}
	
}