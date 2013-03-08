package uhx.oauth.core.requests;

import haxe.ds.StringMap;
import haxe.Http;
import uhx.oauth.core.requests.IRequest;
import uhx.oauth.core.Util;
import uhx.util.URLParser;

using StringTools;
using uhx.util.Helper;

/**
 * ...
 * @author Skial Bainn
 */

/**
 * OAuth protocol params sent from consumer to service prodiver
 * in the HTTP POST request body with a content-type of 
 * application/x-www-form-urlencoded.
 */
class PostRequest extends Request {
	
	public function new() {
		super();
	}
	
	// http://tools.ietf.org/html/rfc5849#section-3.5.2
	override public function request():Void {
		http.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		
		/*for (key in params.keys()) {
			//if (key.startsWith(Util.OAUTH)) {
				http.setParameter(key, params.get(key));
			//}
		}*/
		
		var postData = '';
		
		for (key in params.keys()) {
			postData += (postData == '' ? '' : '&');
			postData += key + '=' + params.get(key).escape();
		}
		
		// now add extra parameters from url
		for (key in url.query.keys()) {
			postData += (postData == '' ? '' : '&');
			postData += key + '=' + url.query.get(key)[0].escape();
		}
		
		http.setPostData(postData);
		
		http.request(true);  // TODO based on httpMethod - pointless really considering the name of this class!
	}
	
	override private function set_url(value:URLParser):URLParser {
		var clone = new URLParser( value.toString() );
		clone.query = new StringMap<Array<String>>();
		url = value;
		http = new Http( clone.toString() );
		return value;
	}
	
}