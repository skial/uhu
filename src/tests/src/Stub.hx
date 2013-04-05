package ;
import uhx.core.Klas;

/**
 * ...
 * @author Skial Bainn
 */
class Stub implements Klas {

	@:after('AllTests') public static function some() {
		trace('From Stub::some');
	}
	
}