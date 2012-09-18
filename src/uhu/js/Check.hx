package uhu.js;

import uhu.js.Console;
import UserAgent;
import UserAgentContext;

/**
 * ...
 * @author Skial Bainn
 */

class Check {
	
	private static var prefixes:Array<String> = ' -webkit- -moz- -o- -ms- '.split(' ');
	private static var omPrefixes:String = 'Webkit Moz O ms';
	private static var cssomPrefixes:Array<String> = omPrefixes.split(' ');
	private static var domPrefixes:Array<String> = omPrefixes.toLowerCase().split(' ');
	private static var checkr:String = 'checkr';
	private static var checkrElement:Element = UserAgent.window.document.createElement(checkr);
	private static var checkrStyle:Object = cast checkrElement.style;
	
	private static function testProperties(properties:Array<Dynamic>, prefixed:Dynamic):Dynamic {
		for (i in properties) {
			if (checkrStyle[i] != null) {
				return untyped prefixed == 'pfx' ? i : true;
			}
		}
		return false;
	}
	
	private static function testDOMProperties(properties:Array<String>, object:Dynamic, element:Dynamic):Dynamic {
		var item:Object;
		
		for (i in properties) {
			item = object[cast i];
			
			if (item != untyped __js__('undefined')) {
				
				if (element == false) return i;
				
				if (Reflect.isFunction(item)) {
					return item;
				}
				
				return item;
				
			}
		}
		
		return false;
	}
	
	private static function testAllProperties(property:String, ?prefixed:Null<Dynamic>, ?element:Dynamic):Dynamic {
		var upperCaseProperty:String = property.charAt(0).toUpperCase() + property.substr(1);
		var properties:Array<String> = (property + ' ' + cssomPrefixes.join(upperCaseProperty + ' ') + upperCaseProperty).split(' ');
		
		if (Std.is(prefixed, String) || prefixed == null) {
			// testProps
			return testProperties(properties, prefixed);
		} else {
			properties = (property + ' ' + domPrefixes.join(upperCaseProperty + ' ') + upperCaseProperty).split(' ');
			// testDOMProps
			return testDOMProperties(properties, prefixed, element);
		}
	}
	
	public static function prefixed(property:String, ?object:Null<Dynamic>, ?element:Dynamic):Dynamic {
		if (object == null) {
			return testAllProperties(property, 'pfx');
		} else {
			return testAllProperties(property, object, element);
		}
	}
	
	// http://caniuse.com/#search=transitions
	public static var cssTransitions(get_cssTransitions, null):Bool;
	
	private static function get_cssTransitions():Bool {
		if (cssTransitions == null) {
			cssTransitions = testAllProperties('transition');
		}
		return cssTransitions;
	}
	
	public static var cssTransforms(get_cssTransforms, null):Bool;
	
	private static function get_cssTransforms():Bool {
		if (cssTransforms == null) {
			cssTransforms = testAllProperties('transform');
		}
		return cssTransforms;
	}
	
	public static var elementFromPoint(get_elementFromPoint, null):Bool;
	
	private static function get_elementFromPoint():Bool untyped {
		return UserAgent.document['elementFromPoint'] != __js__('undefined');
	}
	
}