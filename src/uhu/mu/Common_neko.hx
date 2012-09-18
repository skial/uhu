package uhu.mu;

import sys.FileSystem;
import sys.io.File;
import uhu.mu.typedefs.TParser;
import uhu.mu.Settings;

/**
 * ...
 * @author Skial Bainn
 */

class Common_neko {

	@:PartialReplace
	public static function loadPartial(name:String, leadingWhitespace:String = null):Void->TParser {
		
		name = name + '.' + Settings.TEMPLATE_EXTENSION;
		
		var path:String = FileSystem.fullPath(Settings.TEMPLATE_PATH + name);
		var result:TParser = { template:'', tokens:[] };
		
		if (!_partialCache.exists(name)) {
			
			if (FileSystem.exists(path)) {
				_partialCache.set(name, result);
				var _template:String = File.getContent(path);
				
				if (leadingWhitespace != null || leadingWhitespace != '') {
					_template = ~/^(?=.)/m.replace(_template, leadingWhitespace);
				}
				
				result =  new Parser().parse(_template);
				_partialCache.set(name, result);
			}
			
		} else {
			result = _partialCache.get(name);
		}
		
		return function () { return _partialCache.get(name); };
	}
	
}