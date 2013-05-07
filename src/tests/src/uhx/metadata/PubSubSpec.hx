package uhx.metadata;
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
		
		b.c = { name:'Skial' };
		
		this.assertEquals('Skial', a.c.name);
	}
	
	public function testTriangle() {
		var a = new A();
		var b = new B();
		var c = new C();
		
		c.start = 'Hello Tri Universe';
		
		this.assertEquals('Hello Tri Universe', a.end);
	}
	
}