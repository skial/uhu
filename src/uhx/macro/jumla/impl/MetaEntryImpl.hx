package uhx.macro.jumla.impl;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class MetaEntryImpl {
	
	public var name(get, set):String;

	public function new(entry:MetadataEntry) {
		this.entry = entry;
	}
	
	// ++ internal
	
	@:noCompletion public var entry:MetadataEntry;
	
	private function get_name():String return entry.name;
	
	private function set_name(v:String):String return entry.name = v;
	
	// -- internal
	
}