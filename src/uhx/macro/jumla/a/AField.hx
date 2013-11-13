package uhx.macro.jumla.a;

import haxe.macro.Type;
import haxe.macro.Expr;

/**
 * ...
 * @author Skial Bainn
 */
abstract AField(Field) from Field to Field {

	public var meta(get, set):Metadata;
	public var name(get, set):String;
	public var access(get, set):AAccess;
	
	// ++ internal
	
	@:noCompletion public var original(get, never):Field;
	
	private function get_original():Field return this;
	private function get_meta():Metadata return this.meta;
	private function get_name():String return this.name;
	private function get_access():AAccess return this.access;
	
	private function set_meta(v:Metadata):Metadata return this.meta = v;
	private function set_name(v:String):String return this.name = v;
	private function set_access(v:AAccess):AAccess return this.access = v;
	
	// -- internal
	
}