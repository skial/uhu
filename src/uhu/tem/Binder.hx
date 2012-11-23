package uhu.tem;

import uhu.tem.Common;
import haxe.macro.Expr;

using selecthxml.SelectDom;
using tink.reactive.bindings.BindingTools;

/**
 * ...
 * @author Skial Bainn
 */

class Binder {
	
	public static function parse(html:Xml) {
		
		var instances = html.runtimeSelect('[x-binding]');
		var statics = html.runtimeSelect('[x-binding-static]');
		
		for (i in instances) {
			trace(i);
		}
		
		for (s in statics) {
			trace(s);
		}
		
	}
	
}