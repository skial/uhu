package ;

import Type in StdType;

#if macro
import dtx.XMLWrapper;
import haxe.macro.Expr;
import massive.neko.util.PathUtil;
import sys.FileSystem;
import sys.io.File;
import uhu.tem.Binder;
import uhu.tem.Scope;
import uhu.tem.Common;
import uhu.tem.Validator;
import haxe.macro.Type;
import uhu.macro.Du;
import uhu.macro.Jumla;
import haxe.macro.Context;
import haxe.macro.Compiler;
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
@:ignore
#if !macro
@:autoBuild(uhu.tem.TemMacro.scan())
#end
class Tem {
	
	#if !macro
	public static function main() {
		//Tem.setClasses(['MyClass1', 'MyClass2', 'Class1', 'YourClass']);
		//Tem.setTemplate('templates/vezati/basic.vezati.html');
	}
	#end
	
	/**
	 * Call this method by adding ``--macro Tem.setTemplate("path/to/my/file.html")`` to your ``.hxml`` file.
	 */
	@:macro public static function setTemplate(value:String) {
		var input = MFile.create( FileSystem.fullPath(Context.resolvePath(value)) );
		Common.current_template = input.readString();
		return macro null;
	}
	//17:10
	@:macro public static function compile(path:String) {
		trace('compile');
		var input = MFile.create( FileSystem.fullPath(Context.resolvePath(path)) );
		//var html = input.readString();
		var html = Common.current_template;
		var xml = Scope.parse(html);
		xml = Validator.parse(xml);
		xml = Binder.parse(xml);
		
		// FileSystem.fullPath stops linux from crying
		var output = MFile.create( 
			PathUtil.cleanUpPath(
				FileSystem.fullPath( Compiler.getOutput().substr( 0, Compiler.getOutput().lastIndexOf('/') + 1 ) )
			)
		);
		
		File.saveContent( 
			PathUtil.cleanUpPath(output.nativePath + MFile.seperator + input.fileName), 
			// I dont know how to add a newline with xml.addChild
			xml.toString() + '\n<!-- Generated with Tem (https://github.com/skial/uhu#readme). -->'
		);
		
		return macro null;
	}
	
}

class Class1 implements Tem {
	public function new() { }
	public var format(get_format, set_format):Array<String>;
	
	public function get_format():Array<String> { return []; }
	public function set_format(value:Array<String>):Array<String> { return value; }
}

class MyClass1 implements Tem {
	public function new() { }
	public function fields() { }
	public static var myField = 0;
}

class MyClass2 implements Tem {
	public function new(bob='') { }
	public function fields() { }
	public static var myField = 0;
}

class YourClass implements Tem {
	public static function yourField() {}
}
