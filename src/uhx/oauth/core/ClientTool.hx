package uhx.oauth.core;

import haxe.io.Bytes;
//import jonas.Base16;
//import jonas.HMAC;
import uhx.crypto.HMAC;
import uhx.crypto.Base16;
import uhx.crypto.Base64;
import uhx.oauth.core.requests.IRequest;

using haxe.Utf8;
using StringTools;
using uhx.util.Helper;

/**
 * ...
 * @author Skial Bainn
 */

class ClientTool {
	
	/**
	 * 
	 * @param	c	Accepts uhu.oauth.core.Client instance
	 * @return	{ key:String, sha1:String, digest:String }
	 */
	public static function genSignature(c:Client) {
		var key = c.consumer.secret.encode().escape() + '&' + c.token.secret.encode().escape();
		//var sha1 = HMAC.hmac_sha1(key, c.http_request.base.encode());
		var sha1 = HMAC.sha1(key, c.http_request.base.encode());
		var digest = Base64.encode( Base16.decode16( sha1 ) );
		
		return {
			key:key, sha1:sha1, digest:digest
		}
	}
	
}