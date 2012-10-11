package uhu.mu;

import massive.neko.io.FileSys;
import uhu.mu.typedefs.TParser;
import mpartial.Partial;
import uhu.mu.Settings;

/**
 * ...
 * @author Skial Bainn
 */

#if hocco
@:hocco
#end
class Common implements Partial {
	
	public static var OPENING:String = '{{';
	public static var CLOSING:String = '}}';
	
	//public static var EOL:String = EOL_TYPE();
	//public static var EOLX:String = EOL_TYPE(true);
	
	public static var TAG_TYPES:Array<String> = ['!', '>', '&', '/', '#', '^'];
	
	public static inline var SECTION_UNKNOWN:Int = 0;
	public static inline var SECTION_START:Int = SECTION_UNKNOWN + 1;
	public static inline var SECTION_END:Int = SECTION_START + 1;
	public static inline var SECTION_ARRAY:Int = SECTION_END + 1;
	public static inline var SECTION_OBJECT:Int = SECTION_ARRAY + 1;
	public static inline var SECTION_BOOLEAN:Int = SECTION_OBJECT + 1;
	
	public static var REGEX:EReg = createRegex(OPENING, CLOSING);
	public static var STANDALONE:EReg = createStandalone(OPENING, CLOSING);
	
	public static var _partialCache:Hash<TParser> = new Hash<TParser>();
	
	public static function createRegex(otag:String, ctag:String):EReg {
		// {{([!>&/#^={]?)(\s*\s?[\s\S]+?\s*)([=}]?)}}
		return new EReg(
		'([ \r\n\t]*)' + 
		escapeForEreg(otag) +
		'([!>&/#^={]?)' + 
		'(\\s*\\s?[\\s\\S]+?\\s*)' +
		'([=}]?)' + 
		escapeForEreg(ctag)
		, '');
	}
	
	public static function createStandalone(otag:String, ctag:String):EReg {
		return new EReg(
		'^' + 
		escapeForEreg(otag) +
		'([!>&/#^={]?)' + 
		'(\\s*\\s?[\\s\\S]+?\\s*)' +
		'([=}]?)' + 
		escapeForEreg(ctag) + '([ ]{2,})?$'
		, 'm');
	}
	
	public static function escapeForEreg(value:String):String {
		var SPECIALS:Array<String> = [
			'/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '\\'
		];
		return new EReg('(\\' + SPECIALS.join('|\\') + ')', 'g').replace(value, '\\$1');
	}
	
	public static function loadPartial(name:String, leadingWhitespace:String = null):Void->TParser {
		throw 'This should have been replaced by a target specific method, using the MPartial library by MassiveInteractive.';
		return null;
	}
	
	public static function clearCache():Void {
		_partialCache = new Hash<TParser>();
	}
	
	/*public static function EOL_TYPE(?escaped:Bool = false):String {
		if (FileSys.isLinux) {
			return (escaped ? '\\n' : '\n');
		}
		
		if (FileSys.isWindows) {
			return (escaped ? '\\r\\n' : '\r\n');
		}
		
		if (FileSys.isMac) {
			return (escaped ? '\\r' : '\r');
		}
		
		return (escaped ? '\\r\\n' : '\r\n');
	}*/
	
}