package uhu.macro.jumla;

import haxe.macro.Context;
import haxe.macro.Expr;
import uhu.macro.jumla.t.TComplexString;

/**
 * @author Skial Bainn
 */

class EVarTools {
	
	@:extern public static inline function toString(variable:Var):String {
		return ComplexString.toString( toType( variable ) );
	}
	
	public static function toType(variable:Var):TComplexString {
		var result:TComplexString = null;
		
		if (variable.expr != null) {
			result = ExprTools.toType( variable.expr );
		} else if (variable.type != null) {
			result = ComplexTypeTools.toType( variable.type );
		}
		
		return result;
	}
	
	public static function toFields(variables:Array<Var>):Array<Field> {
		var result = [];
		
		for (v in variables) {
			result.push( toField( v ) );
		}
		
		return result;
	}
	
	public static function toField(variable:Var):Field {
		return {
			name:variable.name,
			doc:null,
			access:[],
			kind:FVar( variable.type, variable.expr ),
			pos: 
			#if !macro 
			{
				file:'',
				min:0,
				max:0
			}
			#else
			Context.currentPos()
			#end
		}
	}
	
}