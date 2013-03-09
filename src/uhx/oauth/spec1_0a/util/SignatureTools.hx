package uhx.oauth.spec1_0a.util;

import uhx.oauth.spec1_0a.e.ESignature;

/**
 * ...
 * @author Skial Bainn
 */

class SignatureTools {
	
	public static function toString(signature:ESignature):String {
		
		return switch(signature) {
			case HMAC_SHA1: 'HMAC-SHA1';
			case RSA_SHA1: 'RSA-SHA1';
			case _: '' + signature;
		}
		
	}
	
}