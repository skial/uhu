package uhx.macro.jumla.a;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

import uhx.macro.jumla.t.RefStruct;
import uhx.macro.jumla.impl.FieldRef;
import uhx.macro.jumla.impl.ClassFieldRef;

/**
 * ...
 * @author Skial Bainn
 */
abstract Reference<T>(RefStruct<T>) {
	
	public var name(get, set):String;
	public var meta(get, set):Meta;
	public var isStatic(get, set):Bool;
	public var isPublic(get, set):Bool;
	
	@:from @:noCompletion public static function fromField(v:Field) {
		return cast new FieldRef( v );
	}
	
	@:from @:noCompletion public static function fromClassField(v:ClassField) {
		return cast new ClassFieldRef( v );
	}
	
	@:to @:noCompletion public function toField():Field return cast this.field;
	@:to @:noCompletion public function toClassField():ClassField return cast this.field;
	
	// ++ internal
	
	@:noCompletion public var field(get, set):T;
	
	private function get_field() return this.field;
	private function get_name() return this.name;
	private function get_meta() return this.meta;
	private function get_isStatic() return this.isStatic;
	private function get_isPublic() return this.isPublic;
	
	private function set_field(v:T) return this.field = v;
	private function set_name(v:String) return this.name = v;
	private function set_meta(v:Meta) return this.meta = v;
	private function set_isStatic(v:Bool) return this.isStatic = v;
	private function set_isPublic(v:Bool) return this.isPublic = v;
	
	// -- internal
	
}