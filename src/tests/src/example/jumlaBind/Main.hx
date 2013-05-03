package example.jumlaBind;

/**
 * ...
 * @author Skial Bainn
 */
class Main {

	public static function main() {
		var a = new A();
		var b = new B();
		
		b.b = 'Hello';
		trace(a.a);
	}
	
}