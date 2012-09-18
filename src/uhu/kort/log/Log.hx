package kort.log;
import massive.neko.cmd.Console;
import massive.neko.io.File;
import kort.enums.LogLevel;
import neko.FileSystem;
import neko.io.Process;
import neko.Sys;

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

class Log {
		
	public static function debug(message:Dynamic):Void
	{
		log(message, LogLevel.debug);
	}
	
	public static function info(message:Dynamic):Void
	{
		log(message, LogLevel.info);
	}
	
	public static function warn(message:Dynamic):Void
	{
		log(message, LogLevel.warn);
	}
	
	public static function error(message:Dynamic):Void
	{
		log(message, LogLevel.error);
	}
	
	public static function fatal(message:Dynamic):Void
	{
		log(message, LogLevel.fatal);
	}
	
	public static function console(message:Dynamic):Void
	{
		log(message, LogLevel.console);
	}
	
	public static function log(message:Dynamic, ?level:LogLevel):Void {
		if(level == null) level = LogLevel.all;
		
		message = Std.string(message);
		
		print(Std.string(level) + ' : ' + message);
	}
	
	public static var print:String->Void;
	
}