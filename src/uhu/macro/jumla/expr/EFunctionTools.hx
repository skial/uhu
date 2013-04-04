package uhu.macro.jumla.expr;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.Timer;

using uhu.macro.Jumla;

/**
 * @author Skial Bainn
 */

class EFunctionTools {
	
	public static function clean(method:Function):Function {
		method.expr = method.expr.clean();
		return method;
	}
	
	public static function toField(method:Function):Field {
		return {
			name:'',
			doc:null,
			access:[],
			kind:FFun( method ),
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