package uhu.tem;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Compiler;

import sys.FileSystem;
import massive.neko.io.File;
import massive.neko.util.PathUtil;

/**
 * ...
 * @author Skial Bainn
 */

class TemMacro {

	@:macro public static function modify():Array<Field> {
		trace('modify');
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		
		if ( Common.index != null && (Context.defined('debug') || Context.defined('js') || Context.defined('nodejs'))  ) {
			
			processTemplate(Common.index);
			
		}
		
		return fields;
	}
	
	public static function processTemplate(value:String) {
		trace('processXML');
		//var input = File.create( FileSystem.fullPath(Context.resolvePath(path)) );
		//var html = input.readString();
		//var html = Common.currentTemplate;
		var html = value;
		var xml = Scope.parse(html);
		xml = Validator.parse(xml);
		xml = Binder.parse(xml);
		
		// FileSystem.fullPath stops linux from crying
		var output = File.create( 
			PathUtil.cleanUpPath(
				FileSystem.fullPath( Compiler.getOutput().substr( 0, Compiler.getOutput().lastIndexOf('/') + 1 ) )
			)
		);
		
		sys.io.File.saveContent( 
			PathUtil.cleanUpPath(output.nativePath + File.seperator + input.fileName), 
			// I dont know how to add a newline with xml.addChild
			xml.toString() + '\n<!-- Generated with Tem (https://github.com/skial/uhu#readme). -->'
		);
		
		return macro null;
	}
	
}