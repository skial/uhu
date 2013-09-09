package uhx.macro;

import utest.Assert;
import help.metadata.pubsub.A;
import help.metadata.pubsub.B;
import help.metadata.pubsub.C;
import help.metadata.pubsub.D;
import help.metadata.pubsub.E;

/**
 * ...
 * @author Skial Bainn
 */
class PubSubSpec {
	
	public var d:D;
	public var e:E;
	
	@:sub(this.d.something) public var something:String;

	public function new() {
		
	}
	
	public function testInstance_staticNotify() {
		var a = new A();
		var b = new B();
		
		b.b = 'Hello Bonded World';	// Little weird...
		
		Assert.equals('Hello Bonded World', a.a);
	}
	
	public function testLocalInstance_instanceNotify() {
		d = new D();
		d.something = 'Hello World 42';
		
		Assert.equals('Hello World 42', this.something);
	}
	
	public function testStatic() {
		B._b = 123;
		
		Assert.equals(123, A._a);
	}
	
	public function testStructure() {
		var a = new A();
		var b = new B();
		
		b.c = { name:'Skial', a:1, b:2 };
		
		Assert.equals('Skial', a.c.name);
	}
	
	public function testInstanceTriangle() {
		var a = new A();
		var b = new B();
		var c = new C();
		
		c.start = 'Hello Instance Tri Universe';
		
		Assert.equals('Hello Instance Tri Universe', a.end);
	}
	
	public function testStaticTriangle() {
		C._start = 'Hello Static Tri Universe';
		
		Assert.equals('Hello Static Tri Universe', A._end);
	}
	
	public function testMixedTriangle() {
		var a = new A();
		
		var c = new C();
		
		c.commencer = 'Hello Tri Verse';
		
		// a => instance
		// b => static
		// c => instance
		
		Assert.equals('Hello Tri Verse', a.fin);
	}
	
	public function testManyInstances() {
		var a = new A();
		var b1 = new B();
		var b2 = new B();
		
		b1.b = 'Hello1';
		
		Assert.equals('Hello1', a.a);
		
		b2.b = 'Hello2';
		
		Assert.equals('Hello2', a.a);
	}
	
}