package uhx.macro.jumla.impl;

import haxe.macro.Type;
import haxe.macro.Expr;
import uhx.macro.jumla.a.Meta;

/**
 * ...
 * @author Skial Bainn
 */
class ClassFieldRef {
	
	public var name(get, set):String;
	public var meta(get, set):Meta;
	public var isStatic(get, never):Bool;
	public var isPublic(get, never):Bool;

	public function new(f:ClassField) {
		trace( f );
		field = f;
	}
	
	// ++ internal
	
	@:noCompletion public var field:ClassField;
	
	private function get_name() return field.name;
	private function get_meta() return field.meta.get();
	private function get_isStatic() return false;
	private function get_isPublic() return field.isPublic;
	
	private function set_name(v:String) return field.name = v;
	private function set_meta(v:Metadata) {
		for (m in field.meta.get()) field.meta.remove( m.name );
		for (m in v) field.meta.add( m.name, m.params, m.pos );
		return v;
	}
	
	// -- internal
	
}