package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.ComplexString;
import uhu.macro.jumla.t.TComplexString;
import uhu.macro.jumla.ExprTools;
import uhu.macro.jumla.ComplexTypeTools;

class TypeParamTools {

	/*@:extern public static inline function toString(t:TypeParam):String {
		return ComplexString.toString( toType(t) );
	}*/

	public static function toString(t:TypeParam):String {
		var result:String = null;
		
		switch (t) {
			case TPType(c):
				result = ComplexTypeTools.toString(c);
			case TPExpr(e):
				result = ExprTools.toString(e);
		}

		return result;
	}

}