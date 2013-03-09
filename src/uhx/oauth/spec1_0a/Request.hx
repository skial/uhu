package uhx.oauth.spec1_0a;

import haxe.Http;
import haxe.ds.StringMap;
import uhx.http.Methods;
import uhx.util.URLParser;
import uhx.oauth.core.Util;
import uhx.oauth.spec1_0a.i.IRequest;

using Lambda;
using StringTools;
using uhx.util.Helper;
using haxe.EnumTools;

/**
 * ...
 * @author Skial Bainn
 */

class Request implements IRequest {
	
	public var http(default, null):Http;
	public var base(get, null):String;
	public var url(default, set):URLParser;
	public var method(default, null):Methods;
	public var params(default, null):StringMap<String>;
	
	public var realm:String;

	public function new() {
		realm = '';
		method = POST;
		params = new StringMap<String>();
	}
	
	public function add(key:String, value:String):Void {
		params.set(key, value);
	}
	
	public function request():Void {
		var data:String = '';
		var post:Bool = false;
		
		switch ( method ) {
			case HEAD:
				data = 'OAuth realm"$realm"';
				
				for (key in params.keys()) {
					data += ',' + key + '="' + params.get(key).escape() + '"';
				}
				
				http.setHeader( 'Authorization', data );
				http.setHeader( 'Content-Type', 'application/x-ww-form-urlencoded' );
				
				data = '';
				
				for (key in url.query.keys()) {
					data += (data == '' ? '' : '&');
					data += key + '=' + url.query.get(key)[0].escape();
				}
				
				http.setPostData( data );
				
				post = true;
			case POST:
				http.setHeader( 'Content-Type', 'application/x-ww-form-urlencoded' );
				
				for (key in params.keys()) {
					data += (data == '' ? '' : '&');
					data += key + '=' + params.get(key).escape();
				}
				
				for (key in url.query.keys()) {
					data += (data == '' ? '' : '&');
					data += key + '=' + url.query.get(key)[0].escape();
				}
				
				http.setPostData( data );
				
				post = true;
			case GET:
				for (key in params.keys()) {
					http.setParameter( key, params.get(key) );
				}
			case _:
		}
		
		http.request( post );
	}
	
	private function get_base():String {
		if (url == null) throw 'You need to set the url for your requests.';
		
		var keys = [];
		var parameters = [];
		var map = new StringMap<String>();
		
		// add the key and values to map
		for (key in url.query.keys()) {
			map.set( key, url.query.get(key)[0] );
		}
		
		// then add oauth key and values to hahs
		for (key in params.keys()) {
			map.set( key, params.get(key) );
		}
		
		// then add all the keys to an array
		for (key in map.keys()) {
			keys.push( key );
		}
		
		// now sort the keys
		keys.sort(Util.stringSort);
		
		for (k in keys) {
			if ( k != Util.SIGNATURE ) {
				parameters.push( k + '=' + '' + map.get(k) );
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
		
		var result = method.getName() + '&' + clone.toString().escape() + '&' + parameters.join('&').escape();
		
		return result;
	}
	
	private function set_url(value:URLParser):URLParser {
		url = value;
		http = new Http( value.toString() );
		return value;
	}
	
}