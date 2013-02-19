package ;

import Type in StdType;
import uhu.tem.TemHelper;

#if macro
import dtx.XMLWrapper;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Compiler;
import sys.FileSystem;
import sys.io.File;
import uhu.tem.Binder;
import uhu.tem.Scope;
import uhu.tem.Common;
import uhu.tem.Validator;
import uhu.macro.Du;
import uhu.macro.Jumla;
import thx.html.Html;
//using uhu.Library;
#end

using StringTools;
using Lambda;

/**
 * ...
 * @author Skial Bainn
 */

/*
 * Might rename to Albert because he's awesome
 * Vezati is "bind" in Croatian
 */

@:keep
#if !macro
@:autoBuild(uhu.tem.TemMacro.modify())
interface Tem { }
#else
class Tem {
	
	/**
	 * Call this method by adding ``--macro Tem.setIndex("path/to/my/file.html")`` to your ``.hxml`` file.
	 */
	public static macro function setIndex(path:String) {
		var input = File.getContent( FileSystem.fullPath( Context.resolvePath(path) ) );
		Common.index = { xml:Html.toXml( input ), path:path };
		return macro null;
	}
	
}
#end

class Class1 implements Tem {
	
	public function new() {	}
	
	public var format(get_format, set_format):Array<Dynamic>;
	
	public function get_format():Array<Dynamic> { return []; }
	public function set_format(value:Array<Dynamic>):Array<Dynamic> { return value; }
	
}

class MyClass1 implements Tem {
	
	public function new() {	}
	
	public function fields() { }
	public static var myField(default,default):String = '';
	
}

class MyClass2 implements Tem {
	
	public function new(bob = '') {	}
	
	public function fields() { }
	public static var myField = 0;
	
}

class YourClass implements Tem {
	public static function yourField() {}
}
