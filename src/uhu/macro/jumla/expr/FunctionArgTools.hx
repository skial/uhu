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
	
	public static function exists(args:Array<FunctionArg>, name:String):Bool {
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
	}
	
}