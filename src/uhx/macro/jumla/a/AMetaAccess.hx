package uhx.macro.jumla.a;

import haxe.macro.Type;
import haxe.macro.Expr;
import uhx.core.Truthy;

using uhx.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
abstract AMetaAccess(MetaAccess) from MetaAccess to MetaAccess {

	@:arrayAccess public function get(key:String):MetadataEntry {
		return this.get().get( key );
	}
	
}