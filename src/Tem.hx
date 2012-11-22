package ;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;
import uhu.tem.Binder;
import uhu.tem.Parser;
import uhu.tem.Common;

#if macro
import haxe.macro.Type;
import uhu.macro.Du;
import uhu.macro.Jumla;
import haxe.macro.Context;
import haxe.macro.Compiler;
using tink.macro.tools.MacroTools;
#end

using tink.core.types.Outcome;

using StringTools;
using uhu.Library;
using Lambda;

/**
 * ...
 * @author Skial Bainn
 */

/*
 * Might rename to Albert because he was awesome
 * Vezati is "bind" in Croatian
 */
class Tem {
	
	private static var userClasses:Array<String> = [];
	
	#if !macro
	public static function main() {
		Tem.setClasses([MyClass, Class1, YourClass]);
		Tem.compile('templates/vezati/basic.vezati.html');
	}
	#end
	
	@:macro public static function setClasses(classes:ExprOf<Array<Class<Dynamic>>>) {
		var user_cls:Array<{cls:ClassType, params:Array<Type>}> = [];
		switch (classes.expr) {
			case EArrayDecl(values):
				
				for (v in values) {
					
					switch (v.expr) {
						case EConst(c):
							var s:String = Jumla.constValue(c);
							user_cls.push(Jumla.getClass( s ));
						default:
					}
					
				}
				
			default:
		}
		
		return macro Void;
	}
	
	@:macro public static function compile(path:String) {
		var html = File.getContent( Context.resolvePath(path) );
		var xml = Parser.parse(html);
		var bind = Binder.parse(xml);
		return macro Void;
	}
	
}