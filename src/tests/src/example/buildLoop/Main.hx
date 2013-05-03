package example.buildLoop;

/**
 * ...
 * @author Skial Bainn
 */
class Main {

	public static function main() {
		new A();
		new B();
	}
	
}

@:build( example.buildLoop.Macro.build() )
class A {
	public function new() {
		
	}
	
	public function foo() {
		
	}
	
	public function bar() {
		
	}
}

class B {
	public function new() {
		
	}
}