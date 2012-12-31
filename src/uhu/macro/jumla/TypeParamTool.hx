package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.ComplexString;
import uhu.macro.jumla.typedefs.TComplexString;
import uhu.macro.jumla.ExprTool;
import uhu.macro.jumla.ComplexTypeTool;

class TypeParamTool {

	@:extern public static inline function toString(t:TypeParam):String {
		return ComplexString.toString( itsType(t) );
	}

	public static function itsType(t:TypeParam):TComplexString {
		var result:TComplexString = null;

		switch (t) {
			case TPType(c):
				result = ComplexTypeTool.itsType(c);
			case TPExpr(e):
				result = ExprTool.itsType(e);
		}

		return result;
	}

}