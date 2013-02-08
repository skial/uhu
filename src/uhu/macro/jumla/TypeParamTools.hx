package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.ComplexString;
import uhu.macro.jumla.t.TComplexString;
import uhu.macro.jumla.ExprTools;
import uhu.macro.jumla.ComplexTypeTools;

class TypeParamTools {

	@:extern public static inline function toString(t:TypeParam):String {
		return Printer.printTypeParam( t );
	}

	public static function toType(t:TypeParam):TComplexString {
		var result = null;
		
		switch (t) {
			case TPType(c):
				result = ComplexTypeTools.toType( c );
			case TPExpr(e):
				result = ExprTools.toType( e );
		}
		
		return result;
	}

}