package uhu.macro.jumla.expr;

import haxe.macro.Expr;

/**
 * @author Skial Bainn
 */

class FunctionTools {

	@:extern public static inline function toString(f:Function):String {
		return Printer.printFunction( f );
	}
	
}