package uhu.tem;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Compiler;
import sys.io.File;

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

	public static macro function modify():Array<Field> {
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		
		if ( Common.index != null /*&& (Context.defined('debug') || Context.defined('js'))*/ ) {
			
			Common.currentFields = [];
			Common.currentStatics = [];
			
			// pick out all the static fields
			for (f in fields) {
				if (f.access.indexOf(AStatic) != -1) {
					Common.currentStatics.push(f);
				} else {
					Common.currentFields.push(f);
				}
			}
			
			if (Context.defined('debug')) {
				/*trace('static count : ' + Common.currentStatics.length);
				trace('instance count : ' + Common.currentFields.length);*/
			}
			
			Common.currentClass = cls;
			
			var xml = Common.index.xml;
			
			xml = Scope.parse(xml);
			xml = Validator.parse(xml);
			
			File.saveContent(Compiler.getOutput() + '.html', xml.toString());
		}
		
		return fields;
	}
	
}