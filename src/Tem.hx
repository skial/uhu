package ;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;
import uhu.tem.Binder;
import uhu.tem.Scope;
import uhu.tem.Common;
import uhu.tem.Validator;

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
	
	#if !macro
	public static function main() {
		Tem.setClasses([MyClass, Class1, YourClass]);
		Tem.compile('templates/vezati/basic.vezati.html');
	}
	#end
	
	@:macro public static function setClasses(classes:ExprOf<Array<Class<Dynamic>>>) {
		
		switch (classes.expr) {
			case EArrayDecl(values):
				
				for (v in values) {
					
					switch (v.expr) {
						case EConst(c):
							var s:String = Jumla.constValue(c);
							var t = Jumla.getClass( s );
							var r = { name:t.cls.pack.join('.') + '.' + t.cls.name, cls:t.cls, params:t.params };
							Common.classes.set(s, r);
						default:
					}
					
				}
				
			default:
		}
		
		return macro Void;
	}
	
	@:macro public static function compile(path:String) {
		var html = File.getContent( Context.resolvePath(path) );
		var xml = Scope.parse(html);
		xml = Validator.parse(xml);
		var bind = Binder.parse(xml);
		
		return macro Void;
	}
	
}

class Class1 {
	public function new() { }
	public var format(get_format, set_format):Array<String>;
	
	public function get_format():Array<String> { return format; }
	public function set_format(value:Array<String>):Array<String> { return value; }
}

class MyClass {
	public function new() { }
	public function fields() { }
	public static var myField = 0;
}

class YourClass {
	public static function yourField() {}
}