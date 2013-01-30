package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.ComplexString;
import uhu.macro.jumla.t.TComplexString;
import uhu.macro.jumla.ExprTool;
import uhu.macro.jumla.ComplexTypeTool;

class TypeParamTool {

	@:extern public static inline function toString(t:TypeParam):String {
		return ComplexString.toString( toType(t) );
	}

	public static function toType(t:TypeParam):TComplexString {
		var result:TComplexString = null;

		switch (t) {
			case TPType(c):
				result = ComplexTypeTool.toType(c);
			case TPExpr(e):
				result = ExprTool.toType(e);
		}

		return result;
	}

}