package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.typedefs.TComplexString;

/**
 * ...
 * @author Skial Bainn
 */

class ExprTool {
	
	@:extern public static inline function toString(e:Expr):String {
		return ComplexString.toString( itsType(e) );
	}

	public static function itsType(e:Expr):TComplexString {
		var result:TComplexString = null;
		
		switch (e.expr) {
			case EConst(c):
				result = ConstantTool.itsType(c);
			case _:
				// TODO handle other types
		}
		
		return result;
	}
	
}