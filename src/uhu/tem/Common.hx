package uhu.tem;

/**
 * ...
 * @author Skial Bainn
 */

typedef StdType = Type;
 
import haxe.macro.Type;
 
typedef TemClass = {
	var name:String;
	var cls:ClassType;
	var params:Array<Type>;
}

class Common {
	
	public static var classes:Hash<TemClass> = new Hash<TemClass>();
	
	public static var x_instance:String = 'x-binding';
	public static var x_static:String = 'x-binding-static';
	
	public static var ignoreClass:Array<String> = ['Class'];
	// This will be improved by detecting invalid characters before searching this.
	public static var ignoreField:Array<String> = [x_instance, x_static];
	
}