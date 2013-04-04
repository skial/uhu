package example.getTypedExpr;

/**
 * ...
 * @author Skial Bainn
 */

@:build( example.getTypedExpr.MyMacro.build() )
class Main {
	
	public static function main() {
		Main.some();
		Foo.thing();
	}
	
	public static function some() {
		trace('Hello');
	}
	
}

class Foo {
	
	public static function thing() {
		trace('World');
	}
	
}