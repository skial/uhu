package kort.cmd;
import massive.neko.cmd.Command;
import massive.neko.io.File;
import neko.FileSystem;

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

class Config extends Command {

	public function new() {
		super();
	}
	
	override public function execute():Void {
		var program:Kort = data.program;
		var arg:String = data.arg;
		
		program.userConfig = File.create(FileSystem.fullPath(arg));
	}
	
}