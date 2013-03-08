package uhx.crypto;
import haxe.unit.TestCase;
import haxe.crypto.Md5;

/**
 * ...
 * @author Skial Bainn
 */
class MD5Spec extends TestCase {

	public var value:String = 'Skial Bainn';
	public var key:String = 'abc123';
	public var expected:String = '8c34c4424b5eabd0565f75ff77b24dc9';
	public var expected_with_key:String = '476b606e22ea134b57a77c7a607514f3';

	public function new() {
		super();
	}
	
	public function testHaxeMD5() {
		assertEquals(expected, Md5.encode(value));
	}
	
}