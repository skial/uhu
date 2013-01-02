package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.typedefs.TComplexString;
import uhu.macro.jumla.TypeParamTool;

/**
 * ...
 * @author Skial Bainn
 */

class ExprTool {
	
	@:extern public static inline function toString(e:Expr):String {
		return ComplexString.toString( itsType(e) );
	}

	public static function itsType(e:Expr):TComplexString {
		var result:TComplexString = null;
		
		switch (e.expr) {
			case EConst(c):
				result = ConstantTool.itsType(c);
			case EBlock(_):
				result = { name:'Dynamic', params:[] };
			case EArrayDecl(values):
				result = { name:'Array', params:[] };
				for (v in values) {
					result.params.push( itsType(v) );
				}
			case ENew(type, _):
				result = { name:type.name, params:[] };
				for (p in type.params) {
					result.params.push( TypeParamTool.itsType(p) );
				}
			case EObjectDecl(_):
				result = { name:'Typedef', params:[] };
			case _:
				// TODO handle other types
				trace('ExprTool - UNKNOWN');
				trace(e.expr);
		}
		
		return result;
	}
	
}