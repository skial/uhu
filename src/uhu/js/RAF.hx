package uhu.js;

#if js
import uhu.js.Console;
import uhu.Library;

import UserAgent;
import UserAgentContext;
#end

using uhu.Library;

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

class RAF {
	
	private static var lastTime:Int = 0;

	public static function __init__():Void {
		var _window:Dynamic = untyped __js__('window');
		/**
		 * http://www.andismith.com/blog/2012/02/modernizr-prefixed/
		 * http://paulirish.com/2011/requestanimationframe-for-smart-animating/
		 * http://my.opera.com/emoller/blog/2011/12/20/requestanimationframe-for-smart-er-animating
		 * 
		 * requestAnimationFrame polyfill by Erik Möller
		 * fixes from Paul Irish and Tino Zijdel
		 * https://gist.github.com/1579671
		 */
		
		#if modernizr
		_window.requestAnimationFrame = Modernizr.prefixed('RequestAnimationFrame', _window).exportProperty();
		_window.cancelAnimationFrame = untyped Modernizr.prefixed('CancelAnimationFrame', _window).exportProperty() || Modernizr.prefixed('CancelRequestAnimationFrame', _window).exportProperty();
		#else
		var vendors:Array<String> = ['ms', 'moz', 'webkit', 'o'];
		for (x in vendors) {
			if (Reflect.hasField(_window, x + 'RequestAnimationFrame')) _window.requestAnimationFrame = untyped _window[vendors[x] + 'RequestAnimationFrame'];
			if (Reflect.hasField(_window, x + 'CancelAnimationFrame')) _window.requestAnimationFrame = untyped _window[vendors[x] + 'CancelAnimationFrame'];
			if (Reflect.hasField(_window, x + 'CancelRequestAnimationFrame')) _window.requestAnimationFrame = untyped _window[vendors[x] + 'CancelRequestAnimationFrame'];
		}
		#end
		
		if (!_window.requestAnimationFrame) {
			_window.requestAnimationFrame = function(_callback:Dynamic, element:HTMLElement) {
				
				var currTime = Date.now().getTime();
				var timeToCall = Math.max(0, 16 - (currTime - lastTime));
				var id = _window.setTimeout(function() {
					_callback(currTime + timeToCall);
				}, timeToCall);
				
				lastTime = untyped currTime + timeToCall;
				return id;
				
			}
			
		}
		
		if (!_window.cancelAnimationFrame) {
			_window.cancelAnimationFrame = function(id) {
				untyped clearTimeout(id);
			}
		}
	}
	
}