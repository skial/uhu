package example.namedArgs;

/**
 * ...
 * @author Skial Bainn
 */
@:build( example.namedArgs.Macro.build() )
class Main {

	public static function main() {
		foo( true, false, true, @:g false );
	}
	
	public static function foo(a:Bool, b:Bool, c:Bool, d:Bool = false, e:Bool = true, f:Bool = false, g:Bool = true) {
		trace('a = $a');
		trace('b = $b');
		trace('c = $c');
		trace('d = $d');
		trace('e = $e');
		trace('f = $f');
		trace('g = $g');
	}
	
}