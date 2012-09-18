package ;

import haxe.io.Eof;
import haxe.io.Input;
import haxe.io.Output;

import hscript.Interp;
import hscript.Parser;

import massive.neko.cmd.CommandLineRunner;
import massive.neko.io.File;
import massive.neko.io.FileSys;
import massive.neko.util.PathUtil;

import neko.FileSystem;
import neko.io.FileOutput;
import neko.io.Process;
import neko.Lib;
import neko.Sys;
import neko.vm.Module;

import uhu.neko.cmd.CommandLineWrapper;

import uhu.kort.log.Log;
import uhu.kort.cmd.Config;
import uhu.kort.cmd.Setup;
import uhu.kort.typedefs.TInputOutput;
import uhu.kort.typedefs.TAction;
import uhu.kort.typedefs.TFileType;
import uhu.kort.typedefs.TStatistics;

using Std;
using StringTools;
using Strings;
using Arrays;

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

class Kort extends CommandLineWrapper {
	
	public var actions:Hash<TAction>;
	public var types:Array<TFileType>;
	public var files:Hash<Array<TInputOutput>>;
	public var paths:Hash<Null<String>>;
	public var stats:TStatistics;
	public var userConfig:File;
	
	public var config(get_config, null):File;
	
	private function get_config():File {
		if (config == null) {
			config = File.create(FileSystem.fullPath('./config.kort.js'));
		}
		return config;
	}
	
	public var pathConfig(get_pathConfig, null):File;
	
	private function get_pathConfig():File {
		if (pathConfig == null) {
			pathConfig = File.create(FileSystem.fullPath('./paths.kort.js'));
		}
		return pathConfig;
	}
	
	public var pid(get_pid, never):Int;
	
	public function get_pid():Int {
		return current_pid();
	}
	
	public static function main() {
		new Kort();
	}
	
	private var sizes:Array<String>;
	private var parser:Parser;
	private var interp:Interp;
	
	public function new():Void {
		super();
	}
	
	override public function initialize():Void {
		sizes = ['bytes', 'Kb', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
		actions = new Hash<TAction>();
		types = new Array<TFileType>();
		files = new Hash<Array<TInputOutput>>();
		paths = new Hash<Null<String>>();
		stats = { original:0, minified:0, savings:0 };
		
		Log.print = this.print;
		
		createCommandMap();
		parser = new Parser();
		parser.allowTypes = true;
		
		interp = new Interp();
		// variables
		interp.variables.set('actions', actions);
		interp.variables.set('types', types);
		interp.variables.set('paths', paths);
		// static fields
		// helper methods
		interp.variables.set('get_size', get_size);
		interp.variables.set('set_input', set_input);
		interp.variables.set('set_output', set_output);
		interp.variables.set('set_recursive', set_recursive);
		interp.variables.set('get_ext', hscript_matchExtension);
		interp.variables.set('isAnimated', hscript_isAnimated);
		interp.variables.set('isWindows', hscript_isWindows);
		interp.variables.set('isLinux', hscript_isLinux);
		interp.variables.set('isMac', hscript_isMac);
	}
	
	override private function createCommandMap():Void {
		mapCommand(Setup, 'setup', ['s'], 'Setup the location of the core programs');
		mapCommand(Config, 'config', ['c'], '<file> Pass a user defined configuration file to kort');
	}
	
	override public function printHeader():Void {
		print('Kort - The extendable all encompassing minifier/optimiser');
	}
	
	override public function printUsage():Void {
		print('Usage : kort [-c] <file>');
	}
	
	override public function checkPriorityCommands():Void {
		// no priority checks needed
	}
	
	override public function runProgram():Void {
		interp.execute(
			parser.parseString(
				pathConfig.readString() + '\n' + config.readString() + '\n' + userConfig.readString()
			)
		);
		
		loopFileTypesArray();
		processActions(files);
		sortOutputFilesBySize();
	}
	
	private function loopFileTypesArray():Void {
		var ereg:EReg;
		var _files:Array<File>;
		var _failed:Array<File>;
		var _tio:Array<TInputOutput>;
		
		for (type in types) {
			
			Log.print('\n----------\nGathering New File Type\n----------');
			Log.info('regular expression - ~/\\' + type.ext + '/i');
			Log.info('recursive - ' + isRecursive);
			
			ereg = new EReg('\\' + type.ext, 'i');
			_failed = new Array<File>();
			
			if (isRecursive) {
				_files = input.getRecursiveDirectoryListing(ereg);
			} else {
				_files = input.getDirectoryListing(ereg);
			}
			
			Log.info('processing ' + _files.length + ' file(s)');
			
			for (file in _files) {
				
				if (type.conditions != null) {
					
					for (cond in type.conditions) {
						if (cond(file) == false) {
							_failed.push(file);
						} else {
							// nout
						}
					}
					
				}
			}
			
			for (f in _failed) {
				_files.remove(f);
			}
			
			Log.info(_failed.length + ' failed, ' + _files.length + ' passed');
			
			if (_files.length != 0) {
				
				_tio = new Array<TInputOutput>();
				
				for (file in _files) {
					_tio.push( { input:file, output:[] } );
				}
				
				files.set(type.ext, _tio);
			}
			
		}
		
	}
	
	private function generateOutput(value:File):File {
		return File.create(value.nativePath.replace(input.nativePath, output.nativePath));
	}
	
	private function processActions(_files:Hash<Array<TInputOutput>>):Void {
		var names:Array<String>;
		
		for (id in files.keys()) {
			names = findActionName(id);
			
			for (name in names) {
				
				Log.print('\n----------\nProcessing New Action\n----------');
				Log.info('action name : ' + name);
				Log.info('extension - ' + files.get(id)[0].input.extension);
				
				processFiles(files.get(id), name);
				
			}
			
		}
		
	}
	
	private function findActionName(type_ext:String):Null<Array<String>> {
		for (type in types) {
			if (type_ext == type.ext) {
				return type.action;
			}
		}
		return null;
	}
	
	private function replaceExpression(expression:String, path:String, input:File, output:File):String {
		return 
		if (expression.indexOf('$input') != -1) {
			
			expression.replace('$input', Sys.escapeArgument(input.nativePath));
			
		} else if (expression.indexOf('$output') != -1) {
			
			expression.replace('$output', Sys.escapeArgument(output.nativePath));
			
		} else if (expression.indexOf('$path') != -1) {
			
			expression.replace('$path', Sys.escapeArgument(path));
			
		} else if (expression.indexOf('$dir') != -1) {
			
			expression.replace('$dir', Sys.escapeArgument(output.parent.nativePath));
			
		} else if (expression.indexOf('$colors') != -1) { 
			
			var _colors:Int = hscript_getColorCount(input);
			
			if (_colors <= 1) _colors = 256;
			
			expression.replace('$colors', Sys.escapeArgument('' + _colors));
			
		} else {
			Sys.escapeArgument(expression);
		}
	}
	
	private function processFiles(arr:Array<TInputOutput>, name:String):Void {
		var _onComplete = new Array<TOnComplete>();
		var _args:Array<String>;
		var _output:File;
		var _cmd:String;
		var _path:String;
		var _action:TAction = actions.get(name);
		var _nativePath:String;
		var _exitCode:Int;
		
		// for conditional args
		var _index:Int;
		var _conditional_cmds:Array<String>;
		var _result:String;
		
		for (io in arr) {
			
			_args = new Array<String>();
			_index = 0;
			_nativePath = io.input.nativePath;
			
			_output = generateOutput(File.create(_nativePath + '.' + name));
			
			if (_action.args != null) {
				
				for (_arg in _action.args) {
					
					_args.push(replaceExpression(_arg, paths.get(name), io.input, _output));
					
					if (_arg.indexOf('$output') != -1 ||
						_arg.indexOf('$dir') != -1) {
						
						io.output.push(_output);
						
					}
					
				}
				
				if (_action.conditions != null) {
					if (_args.exists('$conditions')) _index = _args.indexOf('$conditions');
					
					_conditional_cmds = new Array<String>();
					
					for (c in _action.conditions) {
						
						_result = c(io.input);
						if (_result.trim() != '') {
							_conditional_cmds.push(_result);
						}
						
					}
					
					if (_conditional_cmds.length != 0) {
						
						if (_index == 0) {
							_args = _conditional_cmds.concat(_args);
							_args.remove('$conditions');
						} else {
							var _p1:Array<String> = _args.slice(0, _index);
							var _p2:Array<String> = _args.slice(_index, -1);
							_action.args = _p1.concat(_conditional_cmds).concat(_p2);
						}
					} else {
						_args.remove('$conditions');
					}
					
				}
				
			}
			
			_cmd = replaceExpression(_action.cmd, paths.get(name), io.input, _output);
			
			_path = PathUtil.cleanUpPath(_output.parent.nativePath);
			if (!FileSys.exists(_path)) File.create(_path, null, true);
			
			_exitCode = Sys.command(_cmd, _args);
			
			Log.info('file name : ' + io.input.fileName);
			
			if (_exitCode == 1) {
				if (_output.exists) _output.deleteFile();
				io.output.remove(_output);
			}
			
			if (_action.on_complete != null && _exitCode != 1) {
				
				for (oc in _action.on_complete) {
					
					_onComplete.push( { input:_output, output:io.output, name:oc } );
				}
				
			}
			
		}
		
		if (_onComplete.length != 0) {
			for (oc in _onComplete) {
				
				Log.print('\n----------\nProcessing On Complete Action\n----------');
				Log.info('action name : ' + oc.name);
				
				processFiles([ { input:oc.input, output:oc.output } ], oc.name);
				
			}
		}
	}
	
	private function sortOutputFilesBySize():Void {
		var _arr:Array<TInputOutput>;
		
		for (key in files.keys()) {
			
			_arr = files.get(key);
			
			// remove any fecked outputs
			removeMissingFiles(_arr);
			
			// then sort by size
			for (_io in _arr) {
				if (_io.output.length > 1) {
					
					_io.output.sort(function(a, b) {
						return Ints.compare(
							FileSys.stat(a.nativePath).size, 
							FileSys.stat(b.nativePath).size
						);
					});
					
				}
				keepSmallestFile(_io.input, _io.output, key);
			}
			
		}
		
		stats.savings = stats.original - stats.minified;
		
		Log.print('\n----------\nResult\n----------');
		Log.info('Original size - ' + bytesToString(stats.original));
		Log.info('Minified size - ' + bytesToString(stats.minified));
		Log.info('Total saving of - ' + bytesToString(stats.savings));
	}
	
	private function removeMissingFiles(io:Array<TInputOutput>):Void {
		var _missing:Array<File>;
		
		for (_io in io) {
			if (_io.output.length > 1) {
				
				_missing = new Array<File>();
				
				for (_file in _io.output) {
					
					// if they don't, add to _missing array
					if (!_file.exists) _missing.push(_file);
					
				}
				
				for (_lost in _missing) {
					
					// then remove all _lost files from _io.output
					_io.output.remove(_lost);
					
				}
				
			}
		}
	}
	
	private function keepSmallestFile(input:File, output:Array<File>, id:String):Void {
		var _t:File;
		var _oext:Null<String> = null;
		var _replace:String;
		
		for (type in types) {
			if (type.ext == id) {
				_oext = type.oext;
				break;
			}
		}
		
		// check again! for any missing output files
		//removeMissingFiles([ { input:input, output:output } ]);
		
		/*Log.info('original image size : ' + get_size(input));
		for (o in output) {
			Log.info('>> output image size : ' + get_size(o));
		}*/
		
		if (output.length == 0) {
			input.copyTo(generateOutput(input));
		} else if (get_size(output[0]) >= get_size(input) || get_size(output[0]) == 0) {
			
			input.copyTo(output[0].parent);
			
			for (o in output) {
				if (o.exists) o.deleteFile();
			}
			
			stats.original += get_size(input);
			stats.minified += get_size(input);
			
		} else {
			
			_t = output.shift();
			
			//Log.info('input : ' + input.fileName);
			//Log.info('output : ' + _t.fileName);
			
			stats.original += get_size(input);
			stats.minified += get_size(_t);
			
			if (_oext != null) {
				if (!_oext.startsWith('.')) {
					_oext = '.' + _oext;
				}
				
				_replace =  _t.nativePath.replace(
					_t.fileName, _t.fileName.replace(_t.fileName, input.fileName.replace('.' + input.extension, _oext))
				);
			} else {
				_replace = _t.nativePath.replace(_t.fileName, input.fileName);
			}
			
			//Log.info('replace : ' + _replace);
			
			FileSystem.rename(_t.nativePath, _replace);
			
			for (o in output) {
				if (o.exists) o.deleteFile();
			}
			
		}
		
	}
	
	private function bytesToString(bytes:Int):String {
		// source - http://stackoverflow.com/a/4861090
		var index:Int = Math.floor(Math.log(bytes)/Math.log(1024));
		return toFixed((bytes / Math.pow(1024, index)), 2) + sizes[index];
	}
	
	private function toFixed(value:Float, precision:Int):String {
		// source - http://lists.motion-twin.com/pipermail/haxe/2006-December/006259.html
		var num = value;
	   	num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num.string();
	}
	
	// hscript methods
	
	private function hscript_isAnimated(io:File):Bool {
		var _path:String = paths.get('gifsicle');
		var _result:Bool = false;
		var _process:Process;
		var _stdout:String;
		
		if (_path != null) {
			_process = new Process(_path, ['--info', io.nativePath]);
			_stdout = _process.stdout.readAll().toString();
			
			if (_stdout.indexOf('+ image #1') == -1) {
				_result = false;
			} else {
				_result = true;
			}
			try {
				_process.close();
			} catch (e:Dynamic) {
				_process.kill();
			}
			
		}
		
		return _result;
	}
	
	private function hscript_isWindows(?io:File):Bool {
		if (isWindows) {
			return true;
		} else {
			return false;
		}
	}
	
	private function hscript_isLinux(?io:File):Bool {
		if (isLinux) {
			return true;
		} else {
			return false;
		}
	}
	
	private function hscript_isMac(?io:File):Bool {
		if (isMac) {
			return true;
		} else {
			return false;
		}
	}
	
	private function hscript_matchExtension(ext:String, io:File):Bool {
		if (io.extension == ext) {
			return true;
		} else {
			return false;
		}
	}
	
	private function hscript_getColorCount(io:File):Int {
		var _path:String = paths.get('optipng');
		var _result:Int = 0;
		var _process:Process;
		var _stdout:String;
		
		// 64 colors (33 transparent) in palette
		var _num:String = '([1-9][0-9]{0,2})';
		// ([1-9][0-9]{0,2})\scolors?\s(\(([1-9][0-9]{0,2})\stransparent\))?\s?in\spalette
		var _ereg:EReg = new EReg(Std.format('$_num\\scolors?\\s(\\($_num\\stransparent\\))?\\s?in\\spalette'), 'i');
		
		if (_path != null) {
			_process = new Process(_path, ['−simulate', '−o0', io.nativePath]);
			_stdout = _process.stdout.readAll().toString();
			
			if (_ereg.match(_stdout)) {
				_result = _ereg.matched(1).parseInt();
				if (_result >= 256) _result = 256;
			}
			
			try {
				_process.close();
			} catch (e:Dynamic) {
				_process.kill();
			}
			
		}
		
		return _result;
	}
	
	private function get_size(io:File):Int {
		return FileSys.stat(io.nativePath).size;
	}
	
	private function set_input(path:String):Void {
		input = File.create(FileSystem.fullPath(path));
	}
	
	private function set_output(path:String):Void {
		output = File.create(FileSystem.fullPath(path));
	}
	
	private function set_recursive(value:Bool):Void {
		isRecursive = value;
	}
	
	// load neko primitive?
	private static var current_pid = Lib.load('std', 'sys_get_pid', 0);
	
}