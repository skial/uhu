package uhu.mu;

import sys.FileSystem;
import sys.io.File;
import uhu.mu.typedefs.TParser;
import uhu.mu.Settings;

/**
 * ...
 * @author Skial Bainn
 */

class Common_neko_generated {

	@PartialReplace
	public static function loadPartial(name:String, leadingWhitespace:String = null):Void->TParser {
		
		name = name + '.' + uhu.mu.Settings.TEMPLATE_EXTENSION;
		
		var path:String = sys.FileSystem.fullPath(uhu.mu.Settings.TEMPLATE_PATH + name);
		var result:uhu.mu.typedefs.TParser = { template:'', tokens:[] };
		
		if (!_partialCache.exists(name)) {
			
			if (sys.FileSystem.exists(path)) {
				_partialCache.set(name, result);
				var _template:String = sys.io.File.getContent(path);
				
				if (leadingWhitespace != null || leadingWhitespace != '') {
					_template = ~/^(?=.)/gm.replace(_template, leadingWhitespace);
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