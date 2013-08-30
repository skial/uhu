package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.ExprTools;
import uhu.macro.jumla.ComplexTypeTools;

using uhu.macro.Jumla;

class TypeParamTools {
	
	public static function asComplexType(t:TypeParam):ComplexType {
		var result = null;
		
		switch (t) {
			case TPType( ctype ): result = ctype;
			case _:
		}
		
		return result;
	}

	@:extern public static inline function toString(t:TypeParam):String {
		return t.printTypeParam();
	}

}