package uhu.macro.jumla.expr;

import haxe.macro.Expr;

using uhu.macro.Jumla;

/**
 * @author Skial Bainn
 */

class FunctionArgTools {
	
	public static function qualify(a:FunctionArg):FunctionArg {
		var result:FunctionArg = {
			name: a.name,
			opt: a.opt,
			type: a.type.qualify(),
			value: a.value
		}
		
		return result;
	}

	@:extern public static inline function toString(a:FunctionArg):String {
		return a.printFunctionArg();
	}
	
}