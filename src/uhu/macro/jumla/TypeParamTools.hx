package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.ExprTools;
import uhu.macro.jumla.t.TComplexString;
import uhu.macro.jumla.ComplexTypeTools;
import uhu.macro.jumla.ComplexStringTools;

using uhu.macro.Jumla;

class TypeParamTools {

	@:extern public static inline function toString(t:TypeParam):String {
		return Printer.printTypeParam( t );
	}

	public static function toComplexString(t:TypeParam):TComplexString {
		var result = null;
		
		switch (t) {
			case TPType(c):
				result = ComplexTypeTools.toComplexString( c );
			case TPExpr(e):
				result = ExprTools.toComplexString( e );
		}
		
		return result;
	}

}