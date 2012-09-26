package uhu.js.typedefs;

import js.Dom;

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

typedef TWindow = { > Window,
	function requestAnimationFrame(_callback:Dynamic, ?_element:HtmlDom):Dynamic;
	function cancelAnimationFrame(id:Int):Void;
}