package uhx.sys;

import haxe.rtti.Meta;
import utest.Assert;

/**
 * ...
 * @author Skial Bainn
 */
class LiySpec {

	public function new() {
		
	}
	
	public function testReflection() {
		var ld = new Lod();
		ld.args = ['--a', '1', '-b', '2', '-----c', '3', '-f', '4', '-r', '5', '6'];
		
		var map = ld.parse();
		
		var aaa = new A();
		
		var ly = new Liy();
		ly.args = map;
		ly.fields = Type.getInstanceFields( A );
		ly.meta = Meta.getFields( A );
		ly.obj = aaa;
		
		ly.parse();
		
		Assert.equals('1', aaa.a);
		Assert.equals('2', aaa.b);
		Assert.equals('3', aaa.c);
		Assert.equals('4', aaa.foo);
		Assert.equals(5, aaa.d);
		Assert.equals(6, aaa.e);
	}
	
}

class A {
	
	public var a:String;
	public var b:String;
	public var c:String;
	
	@alias('f')
	public var foo:String;
	
	public var d:Int = 0;
	public var e:Int = 0;
	
	@arity(2)
	@alias('r')
	public function bar(aa:String, bb:String) {
		d = Std.parseInt( aa );
		e = Std.parseInt( bb );
	}
	
	public function new() {
		
	}
	
}