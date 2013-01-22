package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.typedefs.TComplexString;

/**
 * ...
 * @author Skial Bainn
 */

class ConstantTool {
	
	@:extern public static inline function toString(c:Constant):String {
		return ComplexString.toString( itsType(c) );
	}
	
	public static function itsType(c:Constant):TComplexString {
		var result:TComplexString = null;
		
		switch (c) {
			case CInt(v):
				result = { name:'Int', params:[] };
			case CFloat(v):
				result = { name:'Float', params:[] };
			case CString(v):
				result = { name:'String', params:[] };
			case CIdent(s):
				trace('ident');
				trace(s);
			case CRegexp(r, opt):
				result = { name:'EReg', params:[] };
		}
		
		return result;
	}
	
}