package uhu.tem;

/**
 * ...
 * @author Skial Bainn
 */

class Common {
	
	public static var userClasses:Hash<String> = new Hash<String>();
	public static var macroClasses:Hash<String> = new Hash<String>();
	
	public static var ignoreClass:Array<String> = ['Class'];
	// This will be improved by detecting invalid characters before search this.
	public static var ignoreField:Array<String> = ['x-binding', 'x-binding-static'];
	
}