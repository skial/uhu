package example.defineType;

/**
 * ...
 * @author Skial Bainn
 */
@:build( example.defineType.MyMacro.build() )
class Foo {

	public static function hello() {
		trace('hello foo');
	}
	
}