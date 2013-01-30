package uhu.macro.jumla;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.Timer;

/**
 * @author Skial Bainn
 */

class EFunctionTools {
	
	public static function toField(method:Function, name:String):Field {
		if (name == null) {
			name = 'Temp' + Date.now().getTime();
		}
		
		return {
			name:name,
			doc:null,
			access:[],
			kind:FFun( method ),
			pos: {
				file:'',
				min:0,
				max:0
			}
		}
	}
	
}