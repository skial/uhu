package uhu.neko.cmd;

import haxe.PosInfos;
import massive.neko.cmd.CommandLineRunner;
import massive.neko.io.File;
import massive.neko.io.FileSys;
import massive.neko.util.PathUtil;
import neko.io.Process;
import neko.Sys;
import massive.haxe.log.Log;
import massive.neko.cmd.ICommand;

using StringTools;
using Strings;
using Arrays;
using Hashes;

/**
 * ...
 * @author Skial Bainn
 */

typedef TInOut = {
	var input:File;
	var output:File;
}
 
class CommandLineWrapper extends CommandLineRunner {
	
	public var haxeDirectory(get_haxeDirectory, null):String;
	
	private function get_haxeDirectory():String {
		if (haxeDirectory == null) {
			try {
				haxeDirectory = PathUtil.cleanUpPath(Sys.getEnv('HAXEPATH'));
			} catch (e:Dynamic) {
				haxeDirectory = console.dir.parent.parent.parent.nativePath;
			}
		}
		return haxeDirectory;
	}
	
	public var programExtension(get_programExtension, null):String;
	
	private function get_programExtension():String {
		if (programExtension == null) {
			if (isWindows) {
				return '.exe';
			} else {
				return '';
			}
		}
		return programExtension;
	}
	
	public var programName(get_programName, null):String;
	
	private function get_programName():String {
		throw 'You need to override CommandLineWrapper::get_programName. Don\'t call super.get_programName';
		return '';
	}
	
	public var isWindows(get_isWindows, null):Bool;
	
	private function get_isWindows():Bool {
		return FileSys.isWindows;
	}
	
	public var isLinux(get_isLinux, null):Bool;
	
	private function get_isLinux():Bool {
		if (isLinux == null) {
			isLinux = new EReg('linux', 'i').match(Sys.systemName());
		}
		return isLinux;
	}
	
	public var isMac(get_isMac, null):Bool;
	
	private function get_isMac():Bool {
		if (isMac == null) {
			isMac = new EReg('mac', 'i').match(Sys.systemName());
		}
		return isMac;
	}
	
	public var platform(get_platform, null):String;
	
	private function get_platform():String {
		if (platform == null) {
			if (isWindows) platform = 'windows';
			if (isLinux) platform = 'linux';
			if (isMac) platform = 'mac';
		}
		return platform;
	}
	
	public var location(get_location, null):String;
	
	private function get_location():String {
		if (location == null) {
			location = console.originalDir.nativePath + platform + File.seperator;
		}
		return location;
	}
	
	private static var descriptionIndent:Int = 30;
	private static var consoleLineLength:Int = 49;
	
	public var input:File;
	public var output:File;
	
	public var commandQueue:Array<String>;
	public var inOut:Array<TInOut>;
	
	public var isRecursive:Bool;
	
	#if !uhu_command_line
	public var errorMessage:String;
	#end

	public function new() {
		super();
		
		isRecursive = false;
		commandQueue = new Array<String>();
		inOut = new Array<TInOut>();
		
		initialize();
		
		#if uhu_command_line
		run();
		#end
	}
	
	public function initialize():Void {
		createCommandMap();
	}
	
	private function createCommandMap():Void {
		throw 'You need to override CommandLineWrapper::createCommandMap. Don\'t call super.createCommandMap';
	}
	
	override public function run():Void {
		printHeader();
		print('');
		
		if (console.options.exists('help') || console.getNextArg() == 'help') processHelp();
		
		checkPriorityCommands();
		
		if (console.args.length > 0) {
			
			var commandArg:String = console.getNextArg();
			Log.debug('commandArg = ' + commandArg);
			var commandClass:Class<ICommand> = getCommandFromString(commandArg);
			
			runCommand(commandClass);
			
			processOptions();
			
		} else {
			processOptions();
		}
		
		runProgram();
		
	}
	
	override public function printHeader():Void {
		throw 'You need to override CommandLineWrapper::printHeader. Don\'t call super.printHeader';
	}
	
	override public function printUsage():Void {
		throw 'You need to override CommandLineWrapper::printUsage. Don\'t call super.printUsage';
	}
	
	override public function printCommands():Void {
		printUsage();
		print('');
		printHelp();
		
		printLoopCommands(commands);
	}
	
	#if !uhu_command_line
	override private function error(message:Dynamic, ?code:Int = 1, ?posInfos:haxe.PosInfos):Void {
		errorMessage = 'Error: ' + Std.string(message);
	}
	#end
	
	private function printLoopCommands(commands:Array<CommandDef>, ?optional:Bool = true):Void {
		for (cmd in commands) {
			
			if(cmd.hidden == true && Log.logLevel == LogLevel.console) continue;
			
			var alt:String = '';
			
			if (cmd.alt != null && cmd.alt.length > 0) alt = ' -' + cmd.alt.join(',-') + ', ';
			
			var start:String = alt + (optional ? ' -' : '  ') + cmd.name;
			
			if (start.length < descriptionIndent) {
				start += ' '.repeat(descriptionIndent - start.length);
			}
			
			print(start + prettyPrintDescription(cmd.description));
			
		}
		
		print('');
	}
	
	private function prettyPrintDescription(value:String):String {
		var index:Int = 0;
		
		if (value.length > consoleLineLength) {
			index = value.lastIndexOf(' ', consoleLineLength);
			if (index != -1) {
				value = value.substr(0, index) + '\n' + (' '.repeat(descriptionIndent)) + prettyPrintDescription(value.substr(index + 1, value.length));
			}
		}
		
		return value;
	}
	
	private function processOptions():Void {
		var commandClass:Class<ICommand>;
		var commandArg:String = '';
		
		if (console.options.arrayOfKeys().length > 0) {
			
			for (a in console.options.keys()) {
				
				commandArg = a.replace('-', '');
				Log.debug('commandArg = ' + commandArg);
				commandClass = getCommandFromString(commandArg);
				
				if (commandClass != null) {
					runCommand(commandClass, {program:this, arg:console.options.get(commandArg)});
				} else {
					continue;
				}
				
			}
			
		} else if(console.options.arrayOfKeys().length == 0) {
			printCommands();
			error('No arguments passed.');
			exit(0);
		}
	}
	
	private function processHelp():Void {
		var sub:String = console.getNextArg();
		var cmd:CommandDef = getCommandDefFromString(sub);
		
		if (cmd != null) {
			printCommandDetail(cmd);
			exit(0);
		} else if (sub != null) {
			if(sub == "help" || sub == 'true') {
				print("help: help");
				print("  It looks like you need HELP with that HELP command.");
				print("  If recursive commands persist, please seek urgent medical assistance.");  
			}
			else {
				printCommands();
				error("Unknown subcommand: " + sub);
				exit(0);
			}
		} else {
			printCommands();
			exit(0);
		}
	}
	
	public function checkPriorityCommands():Void {
		if (console.options.exists('recursive')) {
			runCommand(getCommandFromString('recursive'), { program:this, arg:'true' } );
			console.options.remove('recursive');
		}
		
		if (console.options.exists('in')) {
			runCommand(getCommandFromString('in'), { program:this, arg:console.options.get('in') } );
			console.options.remove('in');
		} else {
			printUsage();
			print('');
			error('You need to specify a file or directory for [-in]');
		}
		
		if (console.options.exists('out')) {
			runCommand(getCommandFromString('out'), { program:this, arg:console.options.get('out') } );
			console.options.remove('out');
		} else {
			printUsage();
			print('');
			error('You need to specify a file or directory for [-out]');
		}
	}
	
	public function runProgram():Void {
		
		var _location:String = location + programName + programExtension;
		var _cmds:Array<String> = commandQueue;
		var _path:String;
		
		for (io in inOut) {
			_path = PathUtil.cleanUpPath(io.output.parent.nativePath);
			if (!FileSys.exists(_path)) FileSys.createDirectory(_path);
			Sys.command(_location, beforeCommand(io).concat(_cmds).concat(afterCommand(io)));
		}
		
		copyMissedFiles();
	}
	
	private function beforeCommand(io:TInOut):Array<String> {
		throw 'You need to override CommandLineWrapper::beforeCommand. Don\'t call super.beforeCommand';
		return [''];
	}
	
	private function afterCommand(io:TInOut):Array<String> {
		throw 'You need to override CommandLineWrapper::afterCommand. Don\'t call super.afterCommand';
		return [''];
	}
	
	public function copyMissedFiles():Void {
		for (io in inOut) {
			if (!io.output.exists) {
				io.input.copyTo(io.output.parent);
			}
		}
	}
	
	#if !uhu_command_line
	public function reset():Void {
		commandQueue = new Array<String>();
		isRecursive = false;
		inOut = new Array<TInOut>();
		errorMessage = null;
	}
	#end
	
}