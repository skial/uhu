package uhu.macro.jumla.expr;

import haxe.macro.Expr;
import uhu.macro.jumla.t.TComplexString;
import uhu.macro.jumla.ComplexStringTools;

/**
 * @author Skial Bainn
 */

class FunctionTools {

	@:extern public static inline function toString(f:Function):String {
		return Printer.printFunction( f );
	}
	
	public static function toComplexString(f:Function):TComplexString {
		var result = null;
		
		var names = [];
		
		for (a in f.args) {
			names.push( ComplexStringTools.toString( FunctionArgTools.toComplexString( a ) ) );
		}
		
		if (f.ret != null) {
			names.push( ComplexStringTools.toString( ComplexTypeTools.toComplexString( f.ret ) ) );
		}
		
		result = { name: names.join( '->' ), params:[] }; 	//	add f.params to params array
		
		return result;
	}
	
}