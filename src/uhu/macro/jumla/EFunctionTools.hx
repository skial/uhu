package uhu.macro.jumla;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.Timer;

/**
 * @author Skial Bainn
 */

class EFunctionTools {
	
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