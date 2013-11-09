package uhx.macro.jumla.a;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
abstract Klass({original:ClassType, improved:Dynamic}) {

	public var meta(get, set):Meta;
	public var path(get, never):String;
	public var fields(get, set):References;
	
	public function new(obj: { original:ClassType, improved:Dynamic } ) {
		this = obj;
	}
	
	private function get_path():String return this.original.pack.concat([this.original.name]).join('.');
	
	private function get_fields():References {
		return [];
	}
	
	private function set_fields(v:References):References {
		return v;
	}
	
	private function get_meta():Meta return this.original.meta.get();
	private function set_meta(v:Metadata):Meta {
		for (m in this.original.meta.get()) this.original.meta.remove( m.name );
		for (m in v) this.original.meta.add( m.name, m.params, m.pos );
		return v;
	}
	
	@:from @:noCompletion public static function fromClassType(v:ClassType):Klass {
		return new Klass( { original: v, improved: { } } );
	}
	
	@:to @:noCompletion public function toClassType():ClassType {
		return this.original;
	}
	
}