package uhu.tem;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */

class TemMacro {

	@:macro public static function scan():Array<Field> {
		trace('modify');
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		trace(Common.current_template);
		if ( Context.defined('js') || Context.defined('nodejs') ) {
			
			
			
		}
		
		return fields;
	}
	
}