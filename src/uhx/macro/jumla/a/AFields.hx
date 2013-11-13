package uhx.macro.jumla.a;

import haxe.macro.Expr;

using Lambda;
using uhx.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
abstract AFields(Array<Field>) from Array<Field> to Array<Field> {
	
	public var filter(get, never):FilterBy<ManyFields>;
	//public var fmeta(get, never):FilterMeta;
	
	public function iterator():Iterator<AField> untyped {
		return {
			it:this.iterator(),
			hasNext:function():Bool return __this__.it.hasNext(),
			next:function():AField return __this__.it.next(),
		}
	}

	@:arrayAccess @:noCompletion public function getField(name:String):AField {
		return this.get( name );
	}
	
	// ++ internal
	
	//private function get_fmeta():FilterMeta return this;
	private function get_filter():FilterBy<ManyFields> return this;
	
	@:noCompletion public var original(get, never):Array<Field>;
	
	private function get_original():Array<Field> return this;
	
	// -- internal
	
}

abstract ManyFields(AFields) from AFields {
	
	@:noCompletion public var original(get, never):AFields;
	
	private function get_original():AFields return this;
	
}

private abstract FilterMeta(Array<AField>) from Array<AField> {
	
	public function get(key:String):Array<Field> return this.filter( function(f) return f.meta.exists( key ) ).array();
	
	public function exists(key:String):Bool {
		var result:Bool = false;
		
		for (f in this) if (f.meta.exists( key )) {
			result = true;
			break;
		}
		
		return result;
	}
}