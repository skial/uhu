package ;

/**
 * ...
 * @author Skial Bainn
 */
class A /*implements Klas*/ {

	@:after(~/C/) public static function some() {
		trace('From A::some');
	}
	
	@:after(~/C/) public static function thing() {
		trace('From A::thing');
	}
	
}