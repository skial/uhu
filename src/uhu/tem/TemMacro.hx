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
 *  a resource. Only gets checked against its own class.
 */
 
class TemMacro {

	@:macro public static function modify():Array<Field> {
		trace('modify');
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		
		for (f in fields) {
			trace(f.name);
		}
		
		if ( Common.index != null /*&& (Context.defined('debug') || Context.defined('js'))*/ ) {
			
			Common.currentClass = cls;
			
			var xml = Common.index.xml;
			
			xml = Scope.parse(xml);
			xml = Validator.parse(xml);
			
		}
		
		return fields;
	}
	
}