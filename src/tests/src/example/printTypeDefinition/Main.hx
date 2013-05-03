package example.printTypeDefinition;

/**
 * ...
 * @author Skial Bainn
 */
@:build( example.printTypeDefinition.Macro.build() )
class Main {

	public function new() {
		
	}
	
	public static function main() {
		new Main();
		trace('World');
	}
	
}