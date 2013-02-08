package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.t.TComplexString;

/**
 * ...
 * @author Skial Bainn
 */

class ConstantTools {
	
	/*@:extern public static inline function toString(c:Constant):String {
		return ComplexString.toString( toType(c) );
	}*/
	
	public static function toString(c:Constant):String {
		var result:String = null;
		
		switch (c) {
			case CInt(_):
				result = 'Int';
			case CFloat(_):
				result = 'Float';
			case CString(_):
				result = 'String';
			case CIdent(s):
				trace('ident');
				trace(s);
			case CRegexp(_, _):
				result = 'EReg';
		}
		
		return result;
	}
	
}