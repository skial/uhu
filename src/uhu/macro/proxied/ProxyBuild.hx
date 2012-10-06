package uhu.macro.proxied;

import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */

class ProxyBuild {

	public static function build() {
		var current_fields = Context.getBuildFields();
		
		return current_fields;
	}
	
}