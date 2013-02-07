package uhu.macro.jumla;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import uhu.macro.jumla.TypeTools;
import uhu.macro.jumla.t.TComplexString;

/**
 * ...
 * @author Skial Bainn
 */
 
class ComplexTypeTools {
	
	@:extern public static inline function toString(c:ComplexType):String {
		return toType(c).getName();
	}

	// Borrowed from haxe.macro.ComplexTypeTools. This class will be fully replaced by core class.
	static public function toType(c:ComplexType):Type {
		return c == null ? null : Context.typeof( { expr: ECheckType(macro null, c), pos: Context.currentPos() } );
	}
	
}