package ;

import Type in StdType;

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
using uhu.Library;
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
#end
class Tem {
	
	#if !macro
	/*
	 * Tem.hxml entry point
	 */
	public static function main() {
		
	}
	#end
	
	public function new() {
		
	}
	
	/**
	 * Call this method by adding ``--macro Tem.setIndex("path/to/my/file.html")`` to your ``.hxml`` file.
	 */
	@:macro public static function setIndex(path:String) {
		var input = File.getContent( FileSystem.fullPath(Context.resolvePath(path)) );
		Common.index = { xml:Html.toXml( input ), path:path };
		return macro null;
	}
	//17:10
	
}

class Class1 extends Tem {
	
	public function new() {
		super();
	}
	
	public var format(get_format, set_format):Array<String>;
	
	public function get_format():Array<String> { return []; }
	public function set_format(value:Array<String>):Array<String> { return value; }
	
}

class MyClass1 extends Tem {
	
	public function new() {
		super();
	}
	
	public function fields() { }
	public static var myField = 0;
	
}

class MyClass2 extends Tem {
	
	public function new(bob = '') { 
		super();
	}
	
	public function fields() { }
	public static var myField = 0;
	
}

class YourClass extends Tem {
	public static function yourField() {}
}
