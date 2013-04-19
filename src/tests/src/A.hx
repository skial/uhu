package ;

/**
 * ...
 * @author Skial Bainn
 */
class A implements Klas {

	@:after('AllTests') public static function some() {
		trace('From A::some');
	}
	
	@:after('AllTests') public static function thing() {
		trace('From A::thing');
	}
	
}