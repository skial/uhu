package uhu.tem;

import haxe.ds.StringMap;
import uhu.tem.i.ITem;
import uhu.tem.Common;

/**
 * @author Skial Bainn
 */

@:TemIgnore
class TemHelper implements ITem {
	
	public static var runtime_classes:StringMap<String>;
	
	public static function __init__() {
		runtime_classes = new StringMap<String>();
	}
	
	public function new() {
		trace(runtime_classes);
		for (key in runtime_classes.keys()) {
			trace('Class name : $key');
		}
	}
	
}