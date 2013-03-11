package uhx.oauth.spec1_0a;

import uhx.web.URI;
import uhx.oauth.spec1_0a.t.TAccess;
import uhx.oauth.spec1_0a.i.IRequest;
import uhx.oauth.spec1_0a.t.TKeySecret;
import uhx.oauth.spec1_0a.e.ESignature;

using uhx.oauth.spec1_0a.util.ClientTools;
using uhx.oauth.spec1_0a.util.SignatureTools;

/**
 * ...
 * @author Skial Bainn
 */
class Client {
	
	public var consumer:TKeySecret;
	public var token:TKeySecret;
	
	public var access:TAccess;
	
	public var signature:ESignature;
	public var http_request:IRequest;
	
	public static var version:String = '1.0';

	public function new() {
		
		token = { key:'', secret:'' };
		consumer = { key:'', secret:'' };
		
		access = { request:null, auth:null, access:null };
		
		signature = HMAC_SHA1;
		
	}
	
	public function makeRequest(url:URI):IRequest {
		http_request = new Request();
		http_request.url = url;
		
		http_request.add( Common.CONSUMER_KEY, consumer.key );
		http_request.add( Common.TOKEN, token.key );
		http_request.add( Common.SIGNATURE_METHOD, signature.toString() );
		http_request.add( Common.TIMESTAMP, '' + Date.now().getTime() / 1000 );
		http_request.add( Common.NONCE, Common.GENERATE_NONCE() );
		http_request.add( Common.VERSION, Client.version );
		http_request.add( Common.SIGNATURE, this.generateDigest() );
		
		return http_request;
	}
	
}