package kort.typedefs;
import massive.neko.io.File;

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

typedef TInputOutput = {
	// required
	var input:File;
	var output:Array<File>;
}

typedef TOnComplete = { > TInputOutput,
	// required
	var name:String;
}