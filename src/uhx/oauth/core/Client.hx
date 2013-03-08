package uhx.oauth.core;

import de.polygonal.core.math.random.Random;
import haxe.crypto.BaseCode;
import haxe.crypto.Adler32;
import haxe.crypto.Md5;
import haxe.io.Bytes;
import uhx.crypto.Base64;
import uhx.crypto.HMAC;
import uhx.oauth.core.e.ESignatureMethod;
import uhx.oauth.core.requests.AuthHeaderRequest;
import uhx.oauth.core.requests.IRequest;
import uhx.oauth.core.requests.PostRequest;
import uhx.oauth.core.requests.QueryRequest;
import uhx.oauth.core.t.TKeySecret;
import uhx.oauth.core.t.TURLRequest;
import uhx.util.URLParser;

using haxe.Utf8;
using StringTools;
using uhx.util.Helper;
using uhx.util.URLParser;
using uhx.oauth.core.Util;
using uhx.util.ParamParser;
using uhx.oauth.core.ClientTool;

private class CKeySecret {
	
	public var key:String = '';
	public var secret:String = '';
	
	public function new() {
		
	}
	
}

/**
 * ...
 * @author Skial Bainn
 * @link http://hueniverse.com/oauth/guide/authentication/
 */

// Also known as a _consumer_
class Client {
	
	public var consumer(default, null):CKeySecret;
	public var token(default, null):CKeySecret;
	public var signature(default, null):ESignatureMethod;
	
	public var request(default, default):URLParser;		//	used to obtain an unauthorized request token
	public var auth(default, default):URLParser;		//	used to obtain user authorization for consumer access
	public var access(default, default):URLParser;		//	used to exchange user request token for access token
	
	public var version:String = '1.0';					// should be 1.0a but some providers might barf at it TODO make static? move to OAuth?
	
	public var http_request:IRequest;
	
	public function new() {
		consumer = new CKeySecret();
		token = new CKeySecret();
		
		signature = HMAC_SHA1;
	}
	
	/**
	 * Attempts to get a request token and secret.
	 */
	public function getRequestToken() {
		setupRequestAttempt();
		
		http_request.http.onData = onRequestData;
		http_request.http.onError = onRequestError;
		http_request.http.onStatus = onRequestStatus;
		
		http_request.request();
	}
	
	public function setupRequestAttempt() {
		if (http_request != null) return;
		
		http_request = new AuthHeaderRequest();
		http_request.url = request;
		
		http_request.add(Util.CONSUMER_KEY, consumer.key);
		http_request.add(Util.SIGNATURE_METHOD, signature.toString());
		http_request.add(Util.TIMESTAMP, '' + Date.now().getTime() / 1000);
		http_request.add(Util.NONCE, generate_nonce());
		http_request.add(Util.VERSION, version);
		http_request.add(Util.CALLBACK, Util.oob);
		http_request.add(Util.SIGNATURE, this.genSignature().digest);
	}
	
	public function onRequestData(data:String) { // TODO clean this crap up
		trace(data);
		
		var query = data.parseParams();
		
		if ( query.exists(Util.TOKEN) && query.exists(Util.TOKEN_SECRET) ) {
			token.key = query.get( Util.TOKEN )[0];
			token.secret = query.get( Util.TOKEN_SECRET )[0];
		}
		
		// destroy previous request object.
		// TODO create method to destroy everything correctly
		http_request = null;
		
		trace(token);
	}
	
	public function onRequestError(error:String) {
		trace(error);
		http_request = null;
	}
	
	public function onRequestStatus(status:Int) {
		trace(status);
	}
	
	/**
	 * Attempts to exchange the request token and secret
	 * for a access token and secret.
	 */
	public function getAccessToken():Void {
		setupAccessAttempt();
		
		http_request.http.onData = onAccessData;
		http_request.http.onError = onAccessError;
		http_request.http.onStatus = onAccessStatus;
		
		http_request.request();
	}
	
	public function setupAccessAttempt():Void {
		if (http_request != null) return;
		
		http_request = new AuthHeaderRequest();
		http_request.url = access;
		
		http_request.add(Util.CONSUMER_KEY, consumer.key);
		http_request.add(Util.TOKEN, token.key);
		http_request.add(Util.SIGNATURE_METHOD, signature.toString());
		http_request.add(Util.TIMESTAMP, '' + Date.now().getTime() / 1000);
		http_request.add(Util.NONCE, generate_nonce());
		http_request.add(Util.VERSION, version);
		http_request.add(Util.VERIFIER, ''); // TODO
		http_request.add(Util.SIGNATURE, this.genSignature().digest);
	}
	
	public function onAccessData(data:String):Void {
		trace(data);
		
		var query = data.parseParams();
		
		if ( query.exists(Util.TOKEN) && query.exists(Util.TOKEN_SECRET) ) {
			token.key = query.get( Util.TOKEN )[0];
			token.secret = query.get( Util.TOKEN_SECRET )[0];
		}
		
		// destroy previous request object.
		// TODO create method to destroy everything correctly
		request = null;
		
		trace(token);
	}
	
	public function onAccessError(error:String):Void {
		trace(error);
	}
	
	public function onAccessStatus(status:Int):Void {
		trace(status);
	}
	
	public function makeRequest():IRequest {
		http_request = new AuthHeaderRequest();
		http_request.url = auth;
		
		http_request.add(Util.CONSUMER_KEY, consumer.key);
		http_request.add(Util.TOKEN, token.key);
		http_request.add(Util.SIGNATURE_METHOD, signature.toString());
		http_request.add(Util.TIMESTAMP, '' + Date.now().getTime() / 1000);
		http_request.add(Util.NONCE, generate_nonce());
		http_request.add(Util.VERSION, version);
		http_request.add(Util.SIGNATURE, this.genSignature().digest);
		
		return http_request;
	}
	
	public function generate_nonce():String {
		var result = '';
		
		for (i in 0...8) {
			result += Random.randRange(0, 9);
		}
		
		return result;
	}
	
}