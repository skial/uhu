package uhx.crypto;

import utest.Assert;
import haxe.crypto.Md5;

/**
 * ...
 * @author Skial Bainn
 */
class MD5Spec {

	public var value:String = 'Skial Bainn';
	public var key:String = 'abc123';
	public var expected:String = '8c34c4424b5eabd0565f75ff77b24dc9';
	public var expected_with_key:String = '476b606e22ea134b57a77c7a607514f3';

	public function new() {
		
	}
	
	public function testHaxeMD5() {
		Assert.equals(expected, Md5.encode(value));
	}
	
}