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
//import uhu.tem.Binder;
import uhu.macro.Jumla;
//import uhu.tem.Validator;
import uhu.tem.TemMacro;
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

@:TemIgnore
class Tem implements ITem { 
	
	#if macro
	// Call this method by adding `--macro Tem.setIndex("path/to/my/file.html")` to your `.hxml` file.
	public static macro function setIndex(path:String) {
		var input = File.getContent( FileSystem.fullPath( Context.resolvePath(path) ) );
		TemMacro.common = new Common();
		TemMacro.common.html = Html.toXml( input );
		TemMacro.common.file = path;
		return macro null;
	}
	#end
	
	public static function main() {
		trace('Hello World - Tem.hx');
		Tem.Init();
	}
	
	public static function Init():Void {
		var help = new TemHelper();
	}
	
}

class C1 extends Tem {
	
	public var fieldString:String;
	public var fieldInt:Int;
	public var fieldFloat:Float;
	
	public function new() {
		trace( fieldString ); 								//	Should be Hello Haxe World - HTML
		fieldString = 'Hello Haxe Universe - C1.hx';		//	Now lets change the html value
		trace( fieldString );								//	Should now be Hello Haxe Universe - C1.hx
		
		trace(fieldInt);
		trace(fieldFloat);
	}
	
}