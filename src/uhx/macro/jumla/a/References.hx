package uhx.macro.jumla.a;

import haxe.macro.Expr;
import uhu.macro.jumla.Common;

/**
 * ...
 * @author Skial Bainn
 */
abstract References(Array<Field>) from Array<Field> to Array<Field> {
	
	public function exists(name:String):Bool return Common.exists( this, name );
	
	@:arrayAccess @:noCompletion public function getInt(v:Int):Reference<Field> return this[v];
	
	/*@:arrayAccess public function get(name:String):Truthy<Reference<Dynamic>> {
		var result = null;
		for (field in this) if (field.name == name) {
			result = field;
			break;
		}
		return result;
	}*/
	
	@:arrayAccess public function get(name:String):Truthy<Reference<Field>> {
		return getInt(Common.indexOf( this, name ));
	}
	
}