package uhu.tem;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Compiler;

import sys.FileSystem;

using Lambda;

/**
 * ...
 * @author Skial Bainn
 */

/*
 * Possible future metadata -
 *  + `@:template('pathOrHtml')` - optional value. Embeds the Html partial into the generated output as
 *  a resource. Only gets checked against the metadatas class.
 */
 
class TemMacro {

	@:macro public static function modify():Array<Field> {
		trace('modify');
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		
		if ( Common.index != null && (Context.defined('debug') || Context.defined('js') || Context.defined('nodejs'))  ) {
			
			var array = [];
			
			if (Common.partials.indexOf(Common.index) == -1) {
				
			}
			
		}
		
		return fields;
	}
	
	public static function walkXml(value:String) {
		
		
		return macro null;
	}
	
}