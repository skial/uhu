package example.module;

/**
 * ...
 * @author Skial Bainn
 */
//@:build( example.module.MyMacro.build() )
class A {
	public function new() {}
}

@:build( example.module.MyMacro.build() )
class B {
	public function new() {}
}