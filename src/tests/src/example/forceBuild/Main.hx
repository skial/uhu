package example.forceBuild;

/**
 * ...
 * @author Skial Bainn
 */
@:build( example.forceBuild.MyMacro.build() ) class Main {

	public static function main() {
		trace('Hello Landmass');
	}
	
}