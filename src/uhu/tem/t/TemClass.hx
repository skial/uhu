package uhu.tem.t;

#if (macro || TestTem)
import haxe.macro.Type;
#end

/**
 * @author Skial Bainn
 */

typedef TemClass = {
	var name:String;
	
	#if (macro || TestTem)
	var cls:ClassType;
	var params:Array<Type>;
	#end
}