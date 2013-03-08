package uhx.oauth.core.requests;

import haxe.ds.StringMap;
import haxe.ds.StringMap;
import haxe.Http;
import uhx.oauth.core.requests.IRequest;
import uhx.util.URLParser;
import uhx.oauth.core.Util;

using Lambda;
using StringTools;
using uhx.util.Helper;

/**
 * ...
 * @author Skial Bainn
 */

class Request implements IRequest {
	
	public var http(default, null):Http;
	public var base(get_base, null):String;
	public var url(default, set_url):URLParser;
	public var httpMethod(default, null):String;
	public var params(default, null):StringMap<String>;

	public function new() {
		httpMethod = 'POST';
		params = new StringMap<String>();
	}
	
	public function add(key:String, value:String):Void {
		params.set(key, value);
	}
	
	public function request():Void {
		throw 'Not implemented. Dont call super();';
	}
	
	private function get_base():String {
		if (url == null) throw 'You need to set the url for your requests.';
		
		var keys = [];
		var parameters = [];
		var hash = new StringMap<String>();
		
		// add the key and values to hash
		for (key in url.query.keys()) {
			hash.set( key, url.query.get(key)[0] );
		}
		
		// then add oauth key and values to hahs
		for (key in params.keys()) {
			hash.set( key, params.get(key) );
		}
		
		// then add all the keys to an array
		for (key in hash.keys()) {
			keys.push( key );
		}
		
		// now sort the keys
		keys.sort(Util.stringSort);
		
		for (k in keys) {
			if ( k != Util.SIGNATURE ) {
				parameters.push( k + '=' + '' + hash.get(k) );
			}
		}
		
		// need to edit url but dont want values to persist
		var clone = new URLParser( url.toString() );
		
		/**
		 * @link http://tools.ietf.org/html/rfc5849#section-3.4.1.2
		 */
		
		switch (clone.scheme.toLowerCase()) {
			case 'http' | 'https' :
				clone.scheme = clone.scheme.toLowerCase();
			case _:
				clone.scheme = 'http';
		}
		
		// if port is default for http or https then remove it
		switch (clone.port) {
			case '80' if (clone.scheme == 'http'):
				clone.port = '';
			case '443' if (clone.scheme == 'https'):
				clone.port = '';
			case _:
				
		}
		
		// remove any fragment and query params from url
		clone.fragment = '';
		clone.query = new StringMap<Array<String>>();
		
		var result = httpMethod + '&' + clone.toString().escape() + '&' + parameters.join('&').escape();
		
		return result;
	}
	
	private function set_url(value:URLParser):URLParser {
		url = value;
		http = new Http( value.toString() );
		return value;
	}
	
}