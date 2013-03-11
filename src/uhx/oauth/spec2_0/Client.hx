package uhx.oauth.spec2_0;

import uhx.web.URI;
import uhx.oauth.spec2_0.e.EGrant;
import uhx.oauth.spec2_0.i.IRequest;
import uhx.oauth.spec2_0.t.TAccess;

using uhx.web.URLs;

/**
 * ...
 * @author Skial Bainn
 */

class Client {
	
	public var id:String = '';
	public var secret:String = '';
	
	public var url:TAccess;
	public var type:EGrant;
	
	public var http_request:IRequest;
	
	public var state:String = null;
	public var scopes:Array<String>;
	public var scope_separator:String = ' ';

	public function new() {
		
		scopes = [];
		type = Authorization_Code;
		url = { auth:null, access:null, callback:null };
		
	}
	
	public function makeRequest(url:URI):IRequest {
		var clone = url.toString().toURL();
		
		clone.query.set( Common.RESPONSE_TYPE, [ 'code' ] );
		clone.query.set( Common.CLIENT_ID, [ id ] );
		
		// http://tools.ietf.org/html/rfc6749#section-3.1.2
		if (this.url.callback != null) {
			clone.query.set( Common.REDIRECT_URI, [ this.url.callback.toString() ] );
		}
		
		// http://tools.ietf.org/html/rfc6749#section-3.3
		if (scopes.length > 0) {
			clone.query.set( Common.SCOPE, [ scopes.join( scope_separator ) ] );
		}
		
		// http://tools.ietf.org/html/rfc6749#section-10.12
		if (state != null) {
			clone.query.set( Common.STATE, [ state ] );
		}
		trace(clone);
		http_request = new Request();
		http_request.url = clone;
		
		return http_request;
	}
	
}