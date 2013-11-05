package uhu.macro.jumla.type;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class TFunTools {
	
	/*public static function toFunctionArg(arg: { name:String, opt:Bool, t:Type } ):FunctionArg {
		return {
			name: arg.name,
			opt: arg.opt, 
			type: Context.toComplexType( arg.t ),
			value: null
		}
	}
	
	public static function toFunctionArgs(args:Array<{ name:String, opt:Bool, t:Type }>):Array<FunctionArg> {
		var result:Array<FunctionArg> = [];
		
		for (arg in args) result.push( arg.toFunctionArg() );
		
		return result;
	}*/

	public static function toFFun(type:Type):FieldType {
		var result:FieldType = null;
		
		switch ( type ) {
			case TFun(args, ret):
				result = FFun( {
					args: args.map(function(a) return { name:a.name, type:Context.toComplexType(a.t), value:null, opt:a.opt } ),
					ret: Context.toComplexType( ret ),
					expr: null,
					params: []
				} );
				
			case _:
				Context.error('Not a valid type. From TFunTools::toFFun. $type', Context.currentPos());
		}
		
		return result;
	}
	
}