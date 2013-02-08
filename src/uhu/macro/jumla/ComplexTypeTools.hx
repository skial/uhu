package uhu.macro.jumla;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import uhu.macro.jumla.TypeTools;
import uhu.macro.jumla.t.TComplexString;
import uhu.macro.jumla.TypeTools;

/**
 * ...
 * @author Skial Bainn
 */
 
class ComplexTypeTools {
	
	/*@:extern public static inline function toString(c:ComplexType):String {
		return ComplexString.toString( toType( c ) );
	}*/

	public static inline function toString(c:ComplexType):String {
		return Printer.printComplexType( c );
	}
	
}