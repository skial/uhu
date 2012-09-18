package kort.typedefs;

import massive.neko.io.File;

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

typedef TFileType = {
	// required
	var ext:String;
	var action:Array<String>;
	// optional 
	var oext:Null<String>;
	var conditions:Null<Array<File->Bool>>;
}