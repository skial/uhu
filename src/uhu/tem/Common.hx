package uhu.tem;
import haxe.macro.Type;
import Type in StdType;
/**
 * ...
 * @author Skial Bainn
 */

typedef MFile = massive.neko.io.File;
//typedef StdType = Type;
//typedef MacroType = haxe.macro.Type;
 
typedef TemClass = {
	var name:String;
	var cls:ClassType;
	var params:Array<Type>;
}

class Common {
	
	public static var classes:Hash<TemClass> = new Hash<TemClass>();
	
	public static var x_instance:String = 'data-binding';
	public static var x_static:String = 'data-binding-static';
	
	public static var ignoreClass:Array<String> = ['Class'];
	// This will be improved by detecting invalid characters before searching this.
	public static var ignoreField:Array<String> = [x_instance, x_static, 'data-class', 'class', 'data-id', 'id'];
	
}