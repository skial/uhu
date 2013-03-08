package haxe;
import haxe.unit.TestCase;

/**
 * ...
 * @author Skial Bainn
 */
class Utf8Spec extends TestCase {

	public var value:String = '♫£$𤭢';
	public var expected:String = 'â«Â£$ð¤­¢';

	public function new() {
		super();
	}
	
	public function testUTF8encode() {
		assertEquals(expected, Utf8.encode(value));
	}
	
	public function testUTF8decode() {
		assertEquals(value, Utf8.decode(expected));
	}
	
}