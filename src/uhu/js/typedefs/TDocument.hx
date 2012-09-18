package uhu.js.typedefs;

import js.Dom;

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

typedef TDocument = {>Document,
	//function getElementsByClassName(_name:String):HtmlCollection<HtmlDom>;
	function elementFromPoint(left:Int, top:Int):HtmlDom;
}