package uhu.tem;

import sys.io.File;
import sys.FileSystem;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Compiler;

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
	
	public static var common:Common = null;

	public static macro function build():Array<Field> {
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		
		if (common != null && common.html != null) {
			
			common.current.cls = cls;
			common.current.name = cls.name;
			
			var scope = new Scope(common);
			scope.parse();
			
			var bind = new Bind(common);
			bind.parse();
			
		}
		
		return fields;
	}
	
}