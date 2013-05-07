package example.jumlaBind;

/**
 * ...
 * @author Skial Bainn
 */
class Main {

	public static function main() {
		var a = new A();
		var b = new B();
		var c = new C();
		
		b.b = 'Hello';
		trace(a.a);
		trace(a.aa);
		trace(c.c);
	}
	
}