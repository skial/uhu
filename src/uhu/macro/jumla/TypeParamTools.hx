package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.ExprTools;
import uhu.macro.jumla.ComplexTypeTools;

using uhu.macro.Jumla;

class TypeParamTools {

	@:extern public static inline function toString(t:TypeParam):String {
		return Printer.printTypeParam( t );
	}

}