package uhx.macro.jumla.a;

import haxe.macro.Type;
import haxe.macro.Expr;

using uhx.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
abstract ABaseType(BaseType) from BaseType to BaseType {

	public var doc(get, never):String;
	public var name(get, never):String;
	public var pack(get, never):Array<String>;
	public var path(get, never):String;
	public var meta(get, set):AMetaAccess;
	
	// ++ internal
	
	private function get_doc():String return this.doc == null ? '' : this.doc;
	private function get_name():String return this.name;
	private function get_pack():Array<String> return this.pack;
	private function get_path():String return this.pack.concat([this.name]).join('.');
	private function get_meta():AMetaAccess return this.meta;
	
	private function set_meta(v:MetaAccess):AMetaAccess {
		for (m in this.meta.get()) this.meta.remove( m.name );
		for (m in v.get()) this.meta.add( m.name, m.params, m.pos );
		return v;
	}
	
	// -- internal
	
}