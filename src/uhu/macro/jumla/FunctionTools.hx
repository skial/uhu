package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.ComplexString;
import uhu.macro.jumla.t.TComplexString;

/**
 * @author Skial Bainn
 */

class FunctionTools {

	@:extern public static inline function toString(f:Function):String {
		return Printer.printFunction( f );
	}
	
	public static function toType(f:Function):TComplexString {
		var result = null;
		
		var names = [];
		
		for (a in f.args) {
			names.push( ComplexString.toString( FunctionArgTools.toType( a ) ) );
		}
		
		if (f.ret != null) {
			names.push( ComplexTypeTools.toType( f.ret );
		}
		
		return result;
	}
	
}