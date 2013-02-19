package uhu.macro.jumla.expr;

import haxe.macro.Expr;
import uhu.macro.jumla.t.TComplexString;

/**
 * @author Skial Bainn
 */

class FunctionArgTools {

	@:extern public static inline function toString(a:FunctionArg):String {
		return Printer.printFunctionArg( a );
	}
	
	public static function toType(a:FunctionArg):TComplexString {
		return if (a.type != null) {
			
			ComplexTypeTools.toType( a.type );
			
		} else if (a.value != null) {
			
			ExprTools.toType( a.value );
			
		} else {
			
			null;
			
		}
	}
	
}