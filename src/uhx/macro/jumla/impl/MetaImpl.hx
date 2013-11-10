package uhx.macro.jumla.impl;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import uhu.macro.jumla.Common;

/**
 * ...
 * @author Skial Bainn
 */
class MetaImpl {
	
	public function new(meta:Metadata) {
		this.meta = meta;
	}
	
	public function exists(name:String):Bool return Common.exists( meta, name );
	public function get(name:String):MetaEntryImpl return new MetaEntryImpl( Common.get( meta, name ) );
	
	// ++ internal
	
	@:noCompletion public var meta:Metadata;
	
	// -- internal
	
}