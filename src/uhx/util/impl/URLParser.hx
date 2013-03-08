package uhx.util.impl;

import uhx.util.i.IURLParser;
import haxe.ds.StringMap;

using Lambda;
using StringTools;
using uhx.util.Helper;
using uhx.util.ParamParser;

class URLParser implements IURLParser {
	
	// regular expression from http://code.google.com/p/jsuri/source/browse/src/uri.js
	// massive help - thanks!
	@:noComplete
	public static var URL_EREG:EReg = ~/^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/;
	
	@:noComplete
	public static var KEYS = [
		// http://user:pass@www.test.com:81/path/to/index.html?q=books#fragment
		'scheme',	//	http
		'domain',	//	user:pass@www.test.com:81
		'userinfo',	//	user:pass
		'username', //	user
		'password',	//	pass
		'hostname',	//	www.test.com
		'port',		//	81
		'relative',	//	/path/to/index.html?q=books#fragment
		'path',		//	/path/to/index.html
		'directory',//	/path/to/
        'file',		//	index.html
        'query',	//	q=books
        'fragment'	//	fragment
	];
	
	/**
	 * modern? browsers have a native parser, hook into
	 * that for js target.
	 * ```
	 * var p = document.createElement('a');
	 * p.protocol;
	 * p.hostname;
	 * // etc
	 * ```
	 * @link https://gist.github.com/2428561
	 * -----
	 * some data to show that using a regex might be faster?
	 * @link http://jsperf.com/url-parsing/5
	 * -----
	 * very useful post on slicing url's
	 * @link http://tantek.com/2011/238/b1/many-ways-slice-url-name-pieces
	 */
	
	public var scheme(get_scheme, set_scheme):String;
	public var username(get_username, set_username):String;
	public var password(get_password, set_password):String;
	public var hostname(get_hostname, set_hostname):String;
	public var port(get_port, set_port):String;
	public var path(get_path, set_path):String;
	public var query(default, default):StringMap<Array<String>>;
	public var fragment(get_fragment, set_fragment):String;
	
	@:noComplete public var hash:StringMap<String>;
	@:noComplete public var order:StringMap<Int>;
	@:noComplete public var url:String;
	
	public function new(url:String) {
		this.url = url;
		hash = new StringMap<String>();
		order = new StringMap<Int>();
		query = new StringMap<Array<String>>();
		
		for (i in 0...KEYS.length) {
			hash.set(KEYS[1], '');
		}
		
		var _parts = [];
		
		_parts = URL_EREG.toArray(url);
		
		for (i in 0...KEYS.length) {
			hash.set(KEYS[i], _parts[i] == null ? '' : _parts[i]);
		}
		
		if (hash.get('query') != '') {
			query = hash.get('query').parseParams();
		}
		
	}
	
	public function toString():String {
		var result = '';
		
		if (scheme != '') {
			result += '$scheme://';
		}
		
		if (username != '' && password != '') {
			result += '$username:$password@';
		}
		
		if (hostname != '') {
			if (result == '' && ( url.startsWith('//') || url.startsWith('http') )) {
				result += '//';
			}
			
			result += hostname;
			
			if (port != '') {
				result += ':$port';
			}
		}
		
		if (path != '') {
			result += path;
		}
		
		if (query.count() != 0) {
			
			var dot = result.lastIndexOf('.');
			var slash = result.lastIndexOf('/');
			
			if (result != '' && !result.endsWith('/') && (slash == -1)) {
				result += '/';
			}
			
			var queries = '';
			
			var i = 0;
			
			for (k in query.keys()) {
				
				for (q in query.get(k)) {
					
					if (q != null && q.length > 0) {
						if (i != 0) queries += '&';
						queries += k;
						queries += '=' + q;
					}
					
					i++;
				}
				
				i++;
			}
			
			if (queries != '') {
				result += '?$queries';
			}
			
		}
		
		if (fragment != '') {
			
			var dot = result.lastIndexOf('.');
			var slash = result.lastIndexOf('/');
			
			if (result != '' && !result.endsWith('/') && (dot < slash || slash == -1)) {
				result += '/';
			}
			
			if (!fragment.startsWith('#')) {
				result += '#';
			}
			
			result += fragment;
		}
		
		return result;
	}
	
	private function get_scheme():String {
		return hash.get('scheme');
	}
	
	private function set_scheme(value:String):String {
		if (value != '') {
			value = URL_EREG.toArray(value + '://www.test.com')[0];
		}
		hash.set('scheme', value);
		return value;
	}
	
	private function get_username():String {
		return hash.get('username');
	}
	
	private function set_username(value:String):String {
		hash.set('username', value);
		return value;
	}
	
	private function get_password():String {
		return hash.get('password');
	}
	
	private function set_password(value:String):String {
		hash.set('password', value);
		return value;
	}
	
	private function get_hostname():String {
		return hash.get('hostname');
	}
	
	private function set_hostname(value:String):String {
		hash.set('hostname', value);
		return value;
	}
	
	private function get_port():String {
		return hash.get('port');
	}
	
	private function set_port(value:String):String {
		hash.set('port', value);
		return value;
	}
	
	private function get_path():String {
		return hash.get('path');
	}
	
	private function set_path(value:String):String {
		if (value != '') {
			var _p = URL_EREG.toArray(value);
			hash.set('directory', _p[9]);
			hash.set('file', _p[10]);
		} else {
			hash.set('directory','');
			hash.set('file', '');
		}
		hash.set('path', value);
		return value;
	}
	
	private function get_fragment():String {
		return hash.get('fragment');
	}
	
	private function set_fragment(value:String):String {
		if (value != '') {
			value = value.replace('#', '');
		}
		hash.set('fragment', value);
		return value;
	}
	
}