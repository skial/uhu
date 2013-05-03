package example.jumlaModules;

/**
 * ...
 * @author Skial Bainn
 */
class A {
	public function new() {}
}

class B {
	public function new() {}
}

private class B_sub {
	public function new() {}
}

typedef TA = {
	var foo:A;
}

private typedef TA_sub = {
	var foos:Array<TA>;
	var boos:Array<EA>;
}

private enum EA {
	A1;
	A2;
	A3;
}

private enum EA_sub {
	B1;
	B2;
	B3;
}