package ;

import haxe.xml.Parser;
import thx.html.Html;

//using Detox;
using uhu.Library;
using selecthxml.SelectDom;

/**
 * ...
 * @author Skial Bainn
 */

/*
 * "bind" in Croatian
 */
class Vezati {
	
	public static function main() {
		Vezati.compile('templates/vezati/basic.vezati.html'.loadTemplate());
	}
	
	public static function compile(value:String) {
		var xml = Html.toXml(value);
		trace(xml.select('[dtx-repeat]'));
	}
	
}