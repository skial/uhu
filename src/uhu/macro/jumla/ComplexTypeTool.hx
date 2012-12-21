package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.typedefs.TComplexString;

/**
 * ...
 * @author Skial Bainn
 */
 
class ComplexTypeTool {
	
	@:extern public static inline function toString(c:ComplexType):String {
		return ComplexString.toString( itsType(c) );
	}

	public static function itsType(c:ComplexType):TComplexString {
		
		var result:TComplexString = null;
		
		switch (c) {
			case TPath(p):
				
				result = {name:'', params:[]};
				
				if (p.pack.length > 0) {
					// TODO add pack to JumlaType
				}
				
				result.name += p.name;
				
				for (type_param in p.params) {
					
					switch (type_param) {
						case TPType(t): result.params.push(itsType(t));
						case _:
					}
					
				}
				
				// TODO handle p.sub
				
				return result;
			case _:
				// TODO handle all other enums
		}
		
		return result;
		
	}
	
}