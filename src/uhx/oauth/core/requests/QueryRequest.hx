package uhx.oauth.core.requests;

import haxe.Http;

/**
 * ...
 * @author Skial Bainn
 */

/**
 * OAuth protocol params sent from consumer to service prodiver
 * to the URLs in the query part
 */
class QueryRequest extends Request {
	
	public function new() {
		super();
		httpMethod = 'GET';
	}
	
	override public function request():Void {
		
		for (key in params.keys()) {
			http.setParameter(key, params.get(key));
		}
		
		http.request(false);  // TODO based on httpMethod - pointless really considering the name of this class!
	}
	
}