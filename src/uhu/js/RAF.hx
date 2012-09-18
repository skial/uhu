package uhu.js;

import uhu.js.Console;
import uhu.js.Check;
import uhu.Library;

import UserAgent;
import UserAgentContext;

using uhu.Library;

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

class RAF {
	
	private static var lastTime:Int = 0;

	public static function __init__():Void {
		Console.log('RAF');
		var _window:Dynamic = untyped window;
		/**
		 * http://www.andismith.com/blog/2012/02/modernizr-prefixed/
		 * http://paulirish.com/2011/requestanimationframe-for-smart-animating/
		 * http://my.opera.com/emoller/blog/2011/12/20/requestanimationframe-for-smart-er-animating
		 * 
		 * requestAnimationFrame polyfill by Erik Möller
		 * fixes from Paul Irish and Tino Zijdel
		 * https://gist.github.com/1579671
		 */
		
		_window.requestAnimationFrame = Check.prefixed('RequestAnimationFrame', _window);
		_window.cancelAnimationFrame = Check.prefixed('CancelAnimationFrame', _window) || Check.prefixed('CancelRequestAnimationFrame', _window);
		
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