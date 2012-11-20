package ;
import uhu.vezati.Parser;

using uhu.Library;
using Lambda;
using Type;

/**
 * ...
 * @author Skial Bainn
 */

/*
 * TODO - need to rename to something better.
 * "bind" in Croatian
 */
class Vezati {
	
	private static var userClasses:Array<String> = [];
	
	public static function main() {
		Vezati.setClasses([MyClass, Class1, YourClass]);
		Vezati.compile('templates/vezati/basic.vezati.html'.loadTemplate());
	}
	
	public static function setClasses(classes:Array<Class<Dynamic>>) {
		for (c in classes) {
			if (userClasses.indexOf(c.getClassName()) == -1) {
				userClasses.push(c.getClassName());
			}
		}
	}
	
	public static function compile(html:String) {
		var tokens = Parser.parse(html, userClasses);
	}
	
}