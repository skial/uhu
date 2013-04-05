package example.defineType;

/**
 * ...
 * @author Skial Bainn
 */
class Main {
	
	public static function hello() {
		trace('Hello from Main');
		Foo.hello();
	}
	
	public static function main() {
		Main.hello();
	}
	
}