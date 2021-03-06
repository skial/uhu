package uhu.mu;

import haxe.ds.StringMap;

import uhu.mu.t.TParser;
import uhu.mu.Settings;

#if js
import haxe.Http;
#elseif neko
import sys.FileSystem;
import sys.io.File;
#end

/**
 * ...
 * @author Skial Bainn
 */

#if hocco
@:hocco
#end
class Common {
	
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
	
	public static var _partialCache:StringMap<TParser> = new StringMap<TParser>();
	
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
		name = name + '.' + Settings.TEMPLATE_EXTENSION;
		var path:String = Settings.TEMPLATE_PATH + name;
		var result:TParser = { template:'', tokens:[] };
		
		#if neko
		path = FileSystem.fullPath(path);
		#end
		
		if (!_partialCache.exists(name)) {
			
			#if js
			var http = new haxe.Http(path);
			
			http.async = false;
			
			http.onData = function(data:String) {
				var _template:String = data;
				
				if (leadingWhitespace != null || leadingWhitespace != '') {
					_template = ~/^(?=.)/m.replace(_template, leadingWhitespace);
				}
				
				result = new Parser().parse(_template);
				_partialCache.set(name, result);
			}
			
			http.request(false);
			#elseif neko
			if (FileSystem.exists(path)) {
				_partialCache.set(name, result);
				var _template:String = File.getContent(path);
				
				if (leadingWhitespace != null || leadingWhitespace != '') {
					_template = ~/^(?=.)/m.replace(_template, leadingWhitespace);
				}
				
				result =  new Parser().parse(_template);
				_partialCache.set(name, result);
			}
			#end
			
		} else {
			result = _partialCache.get(name);
		}
		
		return function () { return _partialCache.get(name); };
	}
	
	public static function clearCache():Void {
		_partialCache = new StringMap<TParser>();
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