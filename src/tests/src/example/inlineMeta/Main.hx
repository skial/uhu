package example.inlineMeta;

/**
 * ...
 * @author Skial Bainn
 */
@:build( example.inlineMeta.Macro.build() )
class Main {
	
	public static function main() {
		new Main();
	}

	public function new() {
		@:yield a();
	}
	
	public function a() {
		b();
	}
	
	public function b() {
		@:yeild var _a = 1;
	}
	
}