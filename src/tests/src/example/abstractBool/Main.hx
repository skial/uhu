package example.abstractBool;

using Lambda;

/**
 * ...
 * @author Skial Bainn
 */
class Main {

	public static function main() {
		var a = ['a', 'b', 'c'];
		var m:MyArray<String> = a;
		
		if (m['a']) {
			trace( m['a'] );
		}
	}
	
}

/*abstract MyArray(Array<String>) from Array<String> to Array<String> {
	public function new(v:Array<String>) this = v;
	@:arrayAccess public function exists(v:String):Bool return this.indexOf(v) > -1;
	@:arrayAccess public function get(v:String):String return this[this.indexOf(v)];
}
*/

abstract MyArray<T>(Array<T>) from Array<T> to Array<T> {
    @:arrayAccess public function get(v:Int):MyArrayAccess<T> return this[v];
    @:arrayAccess public function exists(v:T):MyArrayAccess<T> return get(this.indexOf(v));
}

abstract MyArrayAccess<T>(T) from T to T {
    @:to public function toBool():Bool return this != null;
}