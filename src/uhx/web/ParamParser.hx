package uhx.web;

import haxe.ds.StringMap;

using uhx.util.Helper;

/**
 * ...
 * @author Skial Bainn
 */

class ParamParser {
	
	public static var EREG:EReg = ~/(?:^|&)([^&=]*)=?([^&]*)/g;
	
	public static function parseParams(params:String):StringMap<Array<String>> {
		var _query = new StringMap<Array<String>>();
		var _parts = [];
		
		_parts = EREG.toArray( params );
		
		var _key = null;
		var _value = null;
		//var _count = 0;
		
		for (i in 0..._parts.length) {
			switch (i % 2) {
				case 0:
					_key = _parts[i];
					//order.set(_parts[i], _count);
					//_count++;
				case 1:
					_value = _parts[i];
			}
			
			if (_key != null && _value != null) {
				
				// check original url string to see if the value
				// was left empty. Have to respect original url.
				if ( params.lastIndexOf(_key + '=') == -1 ) {
					_value = null;
				}
				
				if (_query.exists(_key)) {
					_query.get(_key).push(_value);
				} else {
					_query.set(_key, [_value]);
				}
				
				_key = _value = null;
			}
		}
		
		return _query;
	}
	
}