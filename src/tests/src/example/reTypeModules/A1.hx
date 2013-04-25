package example.reTypeModules;

/**
 * ...
 * @author Skial Bainn
 */
class A1 {
	public function new() {}
}

@:build(example.reTypeModules.MyMacro.build())
class B1 {
	public function new() {}
}

class C1 {
	public function new() {}
}