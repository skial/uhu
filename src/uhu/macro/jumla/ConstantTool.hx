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
			case CInt:
				result = { name:'Int', params:[] };
			case CFloat:
				result = { name:'Float', params:[] };
			case CString:
				result = { name:'String', params:[] };
			case CIdent(s):
				trace('ident');
				trace(s);
			case CRegexp:
				result = { name:'EReg', params:[] };
		}
		
		return result;
	}
	
}