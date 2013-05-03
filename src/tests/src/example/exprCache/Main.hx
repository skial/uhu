package example.exprCache;

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

@:build( example.exprCache.Macro.build() )
class A {
	
	public function new() {
		
	}
	
	public function foo() {
		
	}
	
}

@:build( example.exprCache.Macro.build() )
class B {
	
	public function new() {
		
	}
	
	public function bar() {
		
	}
	
}