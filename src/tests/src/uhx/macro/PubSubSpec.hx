package uhx.macro;

import haxe.unit.TestCase;
import help.metadata.pubsub.A;
import help.metadata.pubsub.B;
import help.metadata.pubsub.C;

/**
 * ...
 * @author Skial Bainn
 */
class PubSubSpec extends TestCase {

	public function new() {
		super();
	}
	
	public function testInstance() {
		var a = new A();
		var b = new B();
		
		b.b = 'Hello Bonded World';	// Little weird...
		
		this.assertEquals('Hello Bonded World', a.a);
	}
	
	public function testStatic() {
		B._b = 123;
		
		this.assertEquals(123, A._a);
	}
	
	public function testStructure() {
		var a = new A();
		var b = new B();
		
		b.c = { name:'Skial', a:1, b:2 };
		
		this.assertEquals('Skial', a.c.name);
	}
	
	public function testInstanceTriangle() {
		var a = new A();
		var b = new B();
		var c = new C();
		
		c.start = 'Hello Instance Tri Universe';
		
		this.assertEquals('Hello Instance Tri Universe', a.end);
	}
	
	public function testStaticTriangle() {
		C._start = 'Hello Static Tri Universe';
		
		this.assertEquals('Hello Static Tri Universe', A._end);
	}
	
	public function testMixedTriangle() {
		var a = new A();
		
		var c = new C();
		
		c.commencer = 'Hello Tri Verse';
		
		// a => instance
		// b => static
		// c => instance
		
		this.assertEquals('Hello Tri Verse', a.fin);
	}
	
}