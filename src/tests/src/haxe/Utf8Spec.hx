package haxe;

import haxe.Utf8;
import utest.Assert;

/**
 * ...
 * @author Skial Bainn
 */
class Utf8Spec {

	public var value:String = '♫£$𤭢';
	public var expected:String = 'â«Â£$ð¤­¢';

	public function new() {
		
	}
	
	public function testUTF8encode() {
		Assert.equals(expected, Utf8.encode(value));
	}
	
	public function testUTF8decode() {
		Assert.equals(value, Utf8.decode(expected));
	}
	
}