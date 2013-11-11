package uhx.macro.jumla.a;

import haxe.macro.Type;
import haxe.macro.Expr;

/**
 * ...
 * @author Skial Bainn
 */
abstract References<T:{name:String}>(Array<T>) from Array<T> to Array<T> {
	
	
	public function iterator():Iterator<Reference<T>> return cast this.iterator();
	
	public function exists(name:String):Bool {
		var result = false;
		
		for (v in this) if (v.name == name) {
			result = true;
			break;
		}
		
		return result;
	}
	
	@:arrayAccess public function get(name:String):Truthy<Reference<T>> {
		var result = null;
		
		for (v in this) if (v.name == name) {
			result = v;
			break;
		}
		
		return cast result;
	}
	
}