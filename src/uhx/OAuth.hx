package uhx;

import haxe.Http;
import uhx.oauth.core.Client;
import uhx.oauth.core.requests.PostRequest;
import uhx.oauth.core.Server;
import uhx.oauth.core.ResourceOwner;
import uhx.oauth.core.Credentials;

using uhx.util.URLParser;

/**
 * ...
 * @author Skial Bainn
 * @link http://term.ie/oauth/example/
 */

class OAuth {
	
	public static function main() {
		
		var c = new Client();
		
		c.consumer.key = 'key';
		c.consumer.secret = 'secret';
		c.request = new URLParser( 'http://term.ie/oauth/example/request_token.php' );
		c.access = new URLParser( 'http://term.ie/oauth/example/access_token.php' );
		c.auth = new URLParser( 'http://term.ie/oauth/example/echo_api.php' );
		
		c.auth.query.set('fname', ['skial']);
		c.auth.query.set('lname', ['bainn']);
		
		c.getRequestToken();
		// TODO send user to authorize the app access, wait for response.
		// TODO the response will be the request token and verification code.
		c.getAccessToken();
		
		// should be able to make protected requests.
		var r = c.makeRequest();
		
		r.http.onData = function(d:String) {
			trace(d);
		}
		
		r.http.onError = function(e:String) {
			trace(e);
		}
		
		r.http.onStatus = function(s:Int) {
			trace(s);
		}
		
		r.request();
	}
	
}