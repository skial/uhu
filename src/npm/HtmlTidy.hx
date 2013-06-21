package npm;

import js.Node;

/**
 * ...
 * @author Skial Bainn
 */
class HtmlTidy {
	
	public static var tidy:String->Config->(String->String->Void)->String = Node.require('htmltidy').tidy;
	
}

typedef Config = {
	@:optional var indent:Bool;
	@:optional var doctype:String;
}

private typedef HTMLTidy = {
	function tidy(html:String, config:Config, callback:String->String->Void):Void;
}