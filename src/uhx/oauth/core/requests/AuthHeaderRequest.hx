package uhx.oauth.core.requests;

import haxe.Http;
import haxe.ds.StringMap;
import uhx.util.URLParser;
import uhx.oauth.core.Util;
import de.polygonal.core.fmt.ASCII;

using Lambda;
using StringTools;
using uhx.util.Helper;

/**
 * ...
 * @author Skial Bainn
 * @link http://oauth.net/core/1.0a/
 */

/**
 * OAuth protocol params sent from consumer to service prodiver
 * in the HTTP Authorization header as defined in 
 * [OAuth HTTP Authorization Scheme](http://oauth.net/core/1.0a/#auth_header)
 * TODO
 *  - Handle optional realm parameter. Section 5.4.1 Authorization Header
 */
class AuthHeaderRequest extends Request {
	
	private var header:String;

	public function new(?realm:String = '') {
		super();
		header = 'OAuth realm="' + realm + '"';
	}
	
	// http://tools.ietf.org/html/rfc5849#section-3.5.1
	override public function request():Void {
		for (key in params.keys()) {
			//if (key.startsWith(Util.OAUTH)) {
				header += ',' + key + '="' + params.get(key).escape() + '"';
			//}
		}
		
		var postData = '';
		// now add extra parameters from url
		for (key in url.query.keys()) {
			postData += (postData == '' ? '' : '&');
			postData += key + '=' + url.query.get(key)[0].escape();
		}
		
		http.setHeader('Authorization', header);
		http.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		http.setPostData(postData);
		http.request(true); // TODO based on httpMethod
	}
	
	override private function set_url(value:URLParser):URLParser {
		var clone = new URLParser( value.toString() );
		clone.query = new StringMap<Array<String>>();
		url = value;
		http = new Http( clone.toString() );
		return value;
	}
	
}