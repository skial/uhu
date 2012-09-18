package kort.cmd;
import hscript.Interp;
import hscript.Parser;
import massive.neko.cmd.Command;
import massive.neko.io.File;
import massive.neko.util.PathUtil;
import neko.FileSystem;
import neko.Lib;

using StringTools;

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

class Setup extends Command {
	
	private var paths:Hash<Null<String>>;
	
	private var parser:Parser;
	private var interp:Interp;
	
	private var program:Kort;

	public function new() {
		super();
		
		paths = new Hash<Null<String>>();
		
		parser = new Parser();
		parser.allowTypes = true;
		
		interp = new Interp();
		interp.variables.set('paths', paths);
	}
	
	override public function execute():Void {
		var arg:String = data.arg;
		
		var cc:String = "";
		var yc:String = "";
		var hc:String = "";
		var op:String = "";
		var pq:String = "";
		var jt:String = "";
		var gf:String = "";
		
		program = data.program;
		
		if (program.pathConfig.exists) {
			interp.execute(parser.parseString(program.pathConfig.readString()));
		}
		
		cc = checkPathsExistence('Google Closure Compiler');
		yc = checkPathsExistence('YUI Compressor');
		hc = checkPathsExistence('HTML Compressor');
		op = checkPathsExistence('OptiPNG');
		pq = checkPathsExistence('PNGQuant');
		jt = checkPathsExistence('JPEG Tran');
		gf = checkPathsExistence('Gifsicle');
		
		program.pathConfig.writeString(Std.format('$cc\n$yc\n$hc\n$op\n$pq\n$jt\n$gf'));
		
		exit(0);
	}
	
	private function checkPathsExistence(name:String):String {
		var lc:String = name.replace(' ', '_').toLowerCase();
		var path:String = if (paths.exists(lc)) {
			var _t = paths.get(lc);
			_t == null ? './ff.ff' : _t;
		} else {
			'./ff.ff';
		}
		var file:File = File.create(FileSystem.fullPath(path));
		
		if (file.exists) {
			switch (console.prompt('The path given for ' + name + ' is still valid. Do you want to keep it [y|n]?', 1)) {
				case 'y', 'Y':
					path = paths.get(lc);
				case 'n', 'N':
					path = console.prompt('Please enter the new path to ' + name, 1);
					file = File.create(FileSystem.fullPath(path));
					
					while (file.exists == false) {
						path = console.prompt('The path you supplied does not exist. Please try again', 1);
						file = File.create(FileSystem.fullPath(path));
					}
				default:
					print('The value you passed does not match Y or N. Keeping current path');
					path = paths.get(lc);
			}
		} else {
			file = File.create(FileSystem.fullPath(console.prompt('Path to ' + name, 1)));
			
			while (file.exists == false) {
				path = console.prompt('The path you supplied does not exist. Please try again', 1);
				file = File.create(FileSystem.fullPath(path));
			}
		}
		
		// hscript fails on unescaped back slash characters - by design or bug. mlib returns platform safe paths, which at least on windows kills hscript :)
		return 'paths.set("' + lc + '", "' + ~/[\\]/.customReplace(file.nativePath, function(e:EReg) return "\\" + e.matched(0)) + '");';
	}
	
}