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
		return Printer.printFunctionArg( a );
	}
	
	/*public static function exists(args:Array<FunctionArg>, name:String):Bool {
		var result = false;
		
		for (arg in args) {
			if (arg.name == name) {
				result = true;
				break;
			}
		}
		
		return result;
	}
	
	public static function get(args:Array<FunctionArg>, name:String):FunctionArg {
		var result = null;
		
		for (arg in args) {
			if (arg.name == name) {
				result = arg;
				break;
			}
		}
		
		return result;
	}*/
	
}