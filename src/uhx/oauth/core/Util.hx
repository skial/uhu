package uhx.oauth.core;
import haxe.crypto.Sha1;
import uhx.oauth.core.e.ESignatureMethod;

using StringTools;

typedef SigTool = ESignatureTool;

/**
 * ...
 * @author Skial Bainn
 * @link http://oauth.net/core/1.0a/
 */

class Util {
	
	/**
	 * OAuth HTTP parameters defined in section 6.1.1
	 */
	
	@:extern public static inline var OAUTH:String = 'oauth_';
	@:extern public static inline var CONSUMER_KEY:String = 'oauth_consumer_key';
	@:extern public static inline var SIGNATURE_METHOD:String = 'oauth_signature_method';
	@:extern public static inline var SIGNATURE:String = 'oauth_signature';
	@:extern public static inline var TIMESTAMP:String = 'oauth_timestamp';
	@:extern public static inline var NONCE:String = 'oauth_nonce';
	@:extern public static inline var VERSION:String = 'oauth_version';
	@:extern public static inline var CALLBACK:String = 'oauth_callback';
	@:extern public static inline var TOKEN:String = 'oauth_token';
	@:extern public static inline var TOKEN_SECRET:String = 'oauth_token_secret';
	@:extern public static inline var CALLBACK_CONFIRMED:String = 'oauth_callback_confirmed';
	@:extern public static inline var VERIFIER:String = 'oauth_verifier';
	
	/**
	 * Helpers
	 */
	
	/**
	 * Used to indicate an out of band configuration. When a consumer
	 * is unable to receive callbacks or a callback URL has been established
	 * by other means.
	 */
	@:extern public static inline var oob:String = 'oob';
	
	public static function stringSort(a:String, b:String):Int {
		a = a.toLowerCase();
		b = b.toLowerCase();
		
		return if (a < b) {
			-1;
		} else if (a > b) {
			1;
		} else {
			0;
		} 
	}
	
	//public static function base64_encode(value:String
	
}