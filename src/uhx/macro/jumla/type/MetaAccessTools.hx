package uhx.macro.jumla.type;

import haxe.macro.Type;
import haxe.macro.Expr;
import uhx.core.Truthy;
import uhx.macro.jumla.a.AMetaAccess;

using uhx.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class MetaAccessTools {

	public static inline function sugar(t:MetaAccess):AMetaAccess return t;
	
	public static function exists(t:MetaAccess, key:String):Bool return t.has( key );
	
	public static function set(t:MetaAccess, key:String, value:MetadataEntry):Void {
		t.add(key, value.params, value.pos);
	}
	
	public static function remove(t:MetaAccess, key:String):Bool {
		t.remove( key );
		return t.exists( key );
	}
	
}