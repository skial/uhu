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
	#else
	var cls:Class<Dynamic>;
	#end
	
	var amount:Int;
}