package uhx.crypto;
import haxe.unit.TestCase;
import haxe.crypto.Sha1;
import uhx.crypto.HMAC;

/**
 * ...
 * @author Skial Bainn
 */
class HMACSpec extends TestCase {

	public var value:String = 'Skial Bainn';
	public var key:String = 'abc123';
	
	public var expected = 'f1501f795478d82ae4e6c1a4371a99e7b9cdab8c';
	public var expected_with_key = 'a43b2464ae7fc37d2bde9a5cbe2a90ef8bfbafa3';

	public function new() {
		super();
	}
	
	public function testHaxeSHA1() {
		assertEquals(expected, Sha1.encode(value));
	}
	
	public function testUhuSHA1_key() {
		assertEquals(expected_with_key, HMAC.sha1(key, value));
	}
	
}