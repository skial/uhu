package uhx.oauth.spec1_0a.util;

import uhx.crypto.HMAC;
import uhx.crypto.Base16;
import uhx.crypto.Base64;
import uhx.oauth.spec1_0a.Client;

using haxe.Utf8;
using StringTools;
using uhx.util.Helper;

/**
 * ...
 * @author Skial Bainn
 */
class ClientTools {
	
	public static function generateKey(client:Client):String {
		
		var key = client.consumer.secret.encode().escape() + '&' + client.token.secret.encode().escape();
		return key;
		
	}
	
	public static function generateSHA1(client:Client):String {
		
		var sha1 = HMAC.sha1( generateKey( client ), client.http_request.base.encode() );
		return sha1;
		
	}

	public static function generateDigest(client:Client):String {
		
		var digest = Base64.encode( Base16.decode16( generateSHA1( client ) ) );
		return digest;
		
	}
	
}