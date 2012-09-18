package uhu.js;

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

// http://developer.apple.com/library/safari/#documentation/appleapplications/Conceptual/Safari_Developer_Guide/DebuggingYourWebsite/DebuggingYourWebsite.html
// then scroll down to Safari JavaScript Console API
 
@:native('console')
extern class Console {
	
	public static var log:Dynamic->Void;
	public static var trace:Dynamic->Void;
	public static var dir:Dynamic->Void;
	
}