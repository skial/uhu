package uhx.oauth.spec2_0;

import uhx.oauth.spec2_0.e.EGrant;
import uhx.oauth.spec2_0.t.TAccess;

/**
 * ...
 * @author Skial Bainn
 */

class Client {
	
	public var id:String = ''
	public var secret:String = '';
	
	public var token:TAccess;
	public var type:EGrant;
	
	public var http_request:Dynamic;

	public function new() {
		
		type = Authorization_Code;
		token = { auth:null, access:null, callback:null };
		
	}
	
}