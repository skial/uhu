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
	
	public static var userClasses:Hash<TemClass> = new Hash<TemClass>();
	
	public static var ignoreClass:Array<String> = ['Class'];
	// This will be improved by detecting invalid characters before search this.
	public static var ignoreField:Array<String> = ['x-binding', 'x-binding-static'];
	
}