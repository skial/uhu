package uhu.js;

import uhu.js.Check;

/**
 * ...
 * @author Skial Bainn
 */

class Fetch {
	
	private static var transitionEndEventNames:Dynamic = {
		'WebkitTransition' : 'webkitTransitionEnd',
		'MozTransition'    : 'transitionend',
		'OTransition'      : 'oTransitionEnd',
		'msTransition'     : 'MSTransitionEnd',
		'transition'       : 'transitionend'
	};
	
	public static var transitionEndName(get_transitionEndName, null):String;
	
	private static function get_transitionEndName():String {
		if (transitionEndName == null) {
			transitionEndName = untyped transitionEndEventNames[Check.prefixed('transition')];
		}
		return transitionEndName;
	}
	
	private static var transformNames:Dynamic = {
		'WebkitTransform' : 'webkitTransform'
	}
	
	public static var transformName(get_transformName, null):String;
	
	private static function get_transformName():String {
		if (transformName == null) {
			transformName = untyped transformNames[Check.prefixed('transform')];
		}
		return transformName;
	}
	
}