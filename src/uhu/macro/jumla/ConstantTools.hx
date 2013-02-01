package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.t.TComplexString;

/**
 * ...
 * @author Skial Bainn
 */

class ConstantTools {
	
	@:extern public static inline function toString(c:Constant):String {
		return ComplexString.toString( toType(c) );
	}
	
	public static function toType(c:Constant):TComplexString {
		var result:TComplexString = null;
		
		switch (c) {
			case CInt(_):
				result = { name:'Int', params:[] };
			case CFloat(_):
				result = { name:'Float', params:[] };
			case CString(_):
				result = { name:'String', params:[] };
			case CIdent(s):
				trace('ident');
				trace(s);
			case CRegexp(_, _):
				result = { name:'EReg', params:[] };
		}
		
		return result;
	}
	
}