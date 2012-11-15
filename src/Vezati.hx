package ;
import uhu.vezati.Parser;

using uhu.Library;

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
	
	public static function compile(html:String) {
		var tokens = Parser.parse(html);
	}
	
}