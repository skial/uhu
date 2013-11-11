package uhx.macro.jumla.impl;

import haxe.macro.Expr;
import uhx.macro.jumla.a.Meta;

using Lambda;

/**
 * ...
 * @author Skial Bainn
 */
class FieldRef {
	
	@:isVar public var name(get, set):String;
	public var meta(get, set):Meta;
	public var isStatic(get, set):Bool;
	public var isPublic(get, set):Bool;

	public function new(f:Field) {
		field = f;
	}
	
	// ++ internal
	
	@:noCompletion public var field:Field;
	
	private function get_name() return field.name;
	private function get_meta() return field.meta;
	private function get_isStatic() return field.access.indexOf( AStatic ) > -1;
	private function get_isPublic() return field.access.indexOf( APublic ) > -1;
	
	private function set_name(v:String) return field.name = v;
	private function set_meta(v:Metadata) return field.meta = v;
	
	private function set_isPublic(v:Bool) {
		if (v) {
			while (field.access.indexOf( APrivate ) > -1) field.access.remove( APrivate );
			field.access.push( APublic );
		} else {
			while (isPublic) field.access.remove( APublic );
			field.access.push( APrivate );
		}
		return v;
	}
	
	private function set_isStatic(v:Bool) {
		if (v) {
			field.access.push( AStatic );
		} else {
			while (isStatic) field.access.remove( AStatic );
		}
		return v;
	}
	
	// -- internal
	
}