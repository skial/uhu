package uhu.mu;

import haxe.Http;
import uhu.mu.typedefs.TParser;
import uhu.mu.Settings;

/**
 * ...
 * @author Skial Bainn
 */

class Common_js {
	
	@:PartialReplace
	public static function loadPartial(name:String, , leadingWhitespace:String = null):Void->TParser {
		
		name = name + '.' + Settings.TEMPLATE_EXTENSION;
		
		var path:String = Settings.TEMPLATE_PATH + name;
		var result:TParser = { template:'', tokens:[] };
		
		if (!_partialCache.exists(name)) {
			
			var http = new haxe.Http(path);
			
			http.async = false;
			
			http.onError = function(data:String) {
				
			}
			
			http.onStatus = function(data:Int) {
				
			}
			
			http.onData = function(data:String) {
				var _template:String = data;
				
				if (leadingWhitespace != null || leadingWhitespace != '') {
					_template = ~/^(?=.)/m.replace(_template, leadingWhitespace);
				}
				
				result = new Parser().parse(_template);
				_partialCache.set(name, result);
			}
			
			http.request(false);
		} else {
			result = _partialCache.get(name);
		}
		
		return function () { return _partialCache.get(name); };
	}
	
}