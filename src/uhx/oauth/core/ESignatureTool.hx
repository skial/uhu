package uhx.oauth.core;

import haxe.crypto.Sha1;
import uhx.oauth.core.e.ESignatureMethod;

/**
 * ...
 * @author Skial Bainn
 */

class ESignatureTool {
	
	public static function toString(s:ESignatureMethod):String {
		return switch(s) {
			case HMAC_SHA1: 'HMAC-SHA1';
			case RSA_SHA1: 'RSA-SHA1';
			case _: '' + s;
		}
	}
	
}