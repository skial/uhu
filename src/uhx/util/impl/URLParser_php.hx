package uhx.util.impl;

import php.Lib;
import php.NativeArray;
import haxe.ds.StringMap;
import uhx.util.i.IURLParser;

using Lambda;
using StringTools;
using uhx.util.Helper;

/**
 * @author Skial Bainn
 */

class URLParser_php implements IURLParser {

	public var scheme(get_scheme, set_scheme):String;
	public var username(get_username, set_username):String;
	public var password(get_password, set_password):String;
	public var hostname(get_hostname, set_hostname):String;
	public var port(get_port, set_port):String;
	public var path(get_path, set_path):String;
	public var query(default, default):StringMap<Array<String>>;
	public var fragment(get_fragment, set_fragment):String;
	
	@:noComplete public var urlParts:Array<String>;
	@:noComplete public var url:String;
	
	public function new(url:String) untyped {
		this.url = url;
		
		if ( !__call__('filter_var', url, __php__('FILTER_VALIDATE_URL')) ) {
			
			if ( !__call__('filter_var', 'http://$url', __php__('FILTER_VALIDATE_URL')) ) {
				urlParts = __call__('parse_url', this.url);
			} else {
				urlParts = __call__('parse_url', 'http://$url');
				scheme = '';
			}
			
		} else {
			urlParts = __call__('parse_url', this.url);
		}
		
		query = new StringMap<Array<String>>();
		
		if ( __call__('isset', urlParts['query']) ) {
			
			var value:String = untyped urlParts['query'];
			var parts:Array<String> = value.split('&');
			var conversion:StringMap<String> = null;
			
			for (part in parts) {
				
				var values = part.split('=');
				var key = null;
				
				value = null;
				
				for (i in 0...values.length) {
					
					switch (i % 2) {
						case 0:
							key = values[i];
						case 1:
							value = values[i];
					}
					
					if (key != null && value != null) {
						if (!query.exists( key )) {
							
							query.set(key, [ value ]);
							
						} else {
							
							query.get( key ).push( value );
							
						}
						
						key = value = null;
					}
				}
				
			}
			
		}
		
	}
	
	public function toString():String {
		var result = '';
		
		if (scheme != '') {
			result += scheme;
			
			if (!scheme.endsWith(':')) {
				result += ':';
			}
			
			result += '//';
		}
		
		if (username != '' && password != '') {
			result += '$username:$password@';
		}
		
		if (hostname != '') {
			if (result == '' && (url.startsWith( '//' ) || url.startsWith( 'http' )) ) {
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
	
	private function get_scheme():String untyped {
		var result = '';
		if (__call__('isset', urlParts['scheme'])) {
			result = urlParts['scheme'];
		}
		return result;
	}
	
	private function set_scheme(value:String):String untyped {
		urlParts['scheme'] = value;
		return value;
	}
	
	private function get_username():String untyped {
		var result = '';
		if (__call__('isset', urlParts['user'])) {
			result = urlParts['user'];
		}
		return result;
	}
	
	private function set_username(value:String):String untyped {
		urlParts['user'] = value;
		return value;
	}
	
	private function get_password():String untyped {
		var result = '';
		if (__call__('isset', urlParts['pass'])) {
			result = urlParts['pass'];
		}
		return result;
	}
	
	private function set_password(value:String):String untyped {
		urlParts['pass'] = value;
		return value;
	}
	
	private function get_hostname():String untyped {
		var result = '';
		if (__call__('isset', urlParts['host'])) {
			result = urlParts['host'];
		}
		return result;
	}
	
	private function set_hostname(value:String):String untyped {
		urlParts['host'] = value;
		return value;
	}
	
	private function get_port():String untyped {
		var result = '';
		if (__call__('isset', urlParts['port'])) {
			result = urlParts['port'];
		}
		return result;
	}
	
	private function set_port(value:String):String untyped {
		urlParts['port'] = value;
		return value;
	}
	
	private function get_path():String untyped {
		var result = '';
		if (__call__('isset', urlParts['path'])) {
			result = urlParts['path'];
		}
		return result;
	}
	
	private function set_path(value:String):String untyped {
		urlParts['path'] = value;
		return value;
	}
	
	private function get_fragment():String untyped {
		var result = '';
		if (__call__('isset', urlParts['fragment'])) {
			result = urlParts['fragment'];
		}
		return result;
	}
	
	private function set_fragment(value:String):String untyped {
		urlParts['fragment'] = value;
		return value;
	}
	
	
}