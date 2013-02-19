package ;

import uhu.tem.i.ITem;
import uhu.tem.TemHelper;

#if macro
import thx.html.Html;
import dtx.XMLWrapper;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Compiler;

import sys.io.File;
import sys.FileSystem;

import uhu.macro.Du;
import uhu.tem.Scope;
import uhu.tem.Common;
import uhu.tem.Binder;
import uhu.macro.Jumla;
import uhu.tem.Validator;
#end

using Lambda;
using StringTools;

/**
 * ...
 * @author Skial Bainn
 */

/*
 * Might rename to Albert because he's awesome
 * Vezati is "bind" in Croatian
 */

class Tem implements ITem { 
	
	#if macro
	/**
	 * Call this method by adding `--macro Tem.setIndex("path/to/my/file.html")` to your `.hxml` file.
	 */
	public static macro function setIndex(path:String) {
		var input = File.getContent( FileSystem.fullPath( Context.resolvePath(path) ) );
		Common.index = { xml:Html.toXml( input ), path:path };
		return macro null;
	}
	#end
	
	public static function init():Void {
		var help = new TemHelper();
	}
	
	#if TestTem
	public static function main() {
		Tem.init();
	}
	#end
	
}

class C1 extends Tem {
	
	public var field:String;
	
	public function new() {
		trace( field ); 	//	Should be Hello World
	}
	
}