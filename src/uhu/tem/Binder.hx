package uhu.tem;

import uhu.tem.Common;
import haxe.macro.Type;

using selecthxml.SelectDom;
using tink.reactive.bindings.BindingTools;

/**
 * ...
 * @author Skial Bainn
 */

class Binder {
	
	public static function parse(html:Xml) {
		
		var instances = html.runtimeSelect('[' + Common.x_instance + ']');
		var statics = html.runtimeSelect('[' + Common.x_static + ']');
		
		for (i in instances) {
			trace(i);
		}
		
		for (s in statics) {
			trace(s);
		}
		
	}
	
	private static function variable(field:ClassField) {
		
	}
	
	private static function method(field:ClassField) {
		
	}
	
}