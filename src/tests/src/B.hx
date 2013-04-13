package ;
import uhx.core.Klas;

/**
 * ...
 * @author Skial Bainn
 */
class B implements Klas {

	@:after('AllTests') public static function thing() {
		trace('From B::thing');
	}
	
}