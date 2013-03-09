package uhx.oauth.spec1_0a;

import de.polygonal.core.math.random.Random;

/**
 * ...
 * @author Skial Bainn
 */

class Common {

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
	
	public static function GENERATE_NONCE():String {
		var result = '';
		
		for (i in 0...8) {
			result += Random.randRange(0, 9);
		}
		
		return result;
	}
	
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
	
}