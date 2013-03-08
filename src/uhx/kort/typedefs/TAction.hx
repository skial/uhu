package kort.typedefs;

import massive.neko.io.File;

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

typedef TAction = {
	// required
	var cmd:String;
	// optional
	var args:Null<Array<String>>;
	var conditions:Null<Array<File->String>>;
	var on_complete:Null<Array<String>>; // the output from this action is passed along to the named on_complete action as the input
}