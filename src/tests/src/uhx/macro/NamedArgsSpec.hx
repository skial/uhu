package uhx.macro;

import utest.Assert;

/**
 * ...
 * @author Skial Bainn
 */
class NamedArgsSpec implements Klas {

	public function new() {
		
	}
	
	public function testNamedArgs() {
		var a = new A( @:a 'Hello' );
		var b = new A( @:b 'World' );
		var c = new A( @:c 'Haxe' );
		var d = new A( @:d 'Foo' );
		var e = new A( @:d '<=', @:a '=>' );
		
		Assert.equals('Hello', a._a);
		Assert.equals('World', b._b);
		Assert.equals('Haxe', c._c);
		Assert.equals('Foo', d._d);
		Assert.equals('<=', e._d);
		Assert.equals('=>', e._a);
	}
	
}

class A {
	
	public var _a:String;
	public var _b:String;
	public var _c:String;
	public var _d:String;
	
	public function new(?a:String, ?b:String, ?c:String, ?d:String) {
		_a = a;
		_b = b;
		_c = c;
		_d = d;
	}
	
}