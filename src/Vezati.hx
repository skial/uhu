package ;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;
import uhu.vezati.Binder;
import uhu.vezati.Parser;
import uhu.vezati.Common;

#if macro
import uhu.macro.Du;
import uhu.macro.Jumla;
import haxe.macro.Context;
import haxe.macro.Compiler;
using tink.macro.tools.MacroTools;
#end

using tink.core.types.Outcome;

using uhu.Library;
using Lambda;

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
		Vezati.compile('templates/vezati/basic.vezati.html');
	}
	
	@:macro public static function setClasses(classes:ExprOf<Array<Class<Dynamic>>>) {
		var user_cls:Array<String> = [];
		switch (classes.expr) {
			case EArrayDecl(values):
				
				for (v in values) {
					
					switch (v.expr) {
						case EConst(c):
							user_cls.push(Jumla.constValue(c));
						default:
					}
					
				}
				
			default:
		}
		trace(user_cls);
		Du.getAllClasses();
		/*for (c in classes) {
			Common.userClasses.set(c.getClassName().split('.').pop(), c.getClassName());
		}*/
		return macro Void;
	}
	
	@:macro public static function compile(path:String) {
		var html = File.getContent( Context.resolvePath(path) );
		var xml = Parser.parse(html);
		var bind = Binder.parse(xml);
		return macro Void;
	}
	
}