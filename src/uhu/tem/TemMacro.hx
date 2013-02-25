package uhu.tem;

import sys.FileStat;
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
			
			common.fields = fields;
			common.current.cls = cls;
			common.current.name = cls.name;
			
			var scope = new Scope(common);
			common.html = scope.parse();
			
			var bind = new Bind(common);
			common.html = bind.parse();
			
			fields = common.fields;
			
			// Write modified html to output directory.
			
			var output_parts = Compiler.getOutput().split('/');
			output_parts.pop();
			
			var output_dir = output_parts.join('/');
			var input_parts = common.file.split('/');
			var input_name = input_parts.pop();
			
			File.saveContent( output_dir + '/' + input_name, common.html.toString() );
			
		}
		
		return fields;
	}
	
}