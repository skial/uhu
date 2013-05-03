package example.printConstructor;

/**
 * ...
 * @author Skial Bainn
 */
@:build( example.printConstructor.Macro.build() )
class Main {

	public function new() {
		
	}
	
	public static function main() {
		new Main();
		trace('World');
	}
	
}