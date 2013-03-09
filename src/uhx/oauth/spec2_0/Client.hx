package uhx.oauth.spec2_0;

import uhx.util.URLParser;
import uhx.oauth.spec2_0.e.EGrant;
import uhx.oauth.spec2_0.i.IRequest;
import uhx.oauth.spec2_0.t.TAccess;

/**
 * ...
 * @author Skial Bainn
 */

class Client {
	
	public var id:String = ''
	public var secret:String = '';
	
	public var url:TAccess;
	public var type:EGrant;
	public var scopes:Array<String>;
	public var http_request:IRequest;
	
	public var state:String = null;

	public function new() {
		
		scopes = [];
		type = Authorization_Code;
		url = { auth:null, access:null, callback:null };
		
	}
	
	public function makeRequest(url:URLParser):IRequest {
		http_request = new Request();
		http_request.url = url;
		
		http_request.add( Common.RESPONSE_TYPE, 'code' );
		http_request.add( Common.CLIENT_ID, id );
		
		// http://tools.ietf.org/html/rfc6749#section-3.1.2
		if (url.callback != null) {
			http_request.add( Common.REDIRECT_URI, url.callback );
		}
		
		// http://tools.ietf.org/html/rfc6749#section-3.3
		if (scopes.length > 0) {
			http_request.add( Common.SCOPE, scopes.join(' ') );
		}
		
		// http://tools.ietf.org/html/rfc6749#section-10.12
		if (state != null) {
			http_request.add( Common.STATE, state );
		}
		
		return http_request;
	}
	
}