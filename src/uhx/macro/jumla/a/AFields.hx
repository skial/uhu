package uhx.macro.jumla.a;

import haxe.macro.Expr;

using uhx.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
abstract AFields(Array<Field>) from Array<Field> to Array<Field> {
	
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
	
}