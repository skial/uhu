package uhu.tem;

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
		
		for (instance in instances) {
			
		}
		
	}
	
}