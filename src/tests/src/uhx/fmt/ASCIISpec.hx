package uhx.fmt;

import utest.Assert;

/**
 * ...
 * @author Skial Bainn
 */

class ASCIISpec {

	public function new() {
		
	}
	
	public function testValue_NUL() {
		Assert.equals(0, ASCII.NUL);
	}
	
	public function testToString_NUL() {
		var e:String = '\\0';
		var a:String = ASCII.NUL;
		Assert.equals(e, a);
	}
	
	public function testValue_ZERO() {
		Assert.equals(48, ASCII.ZERO);
	}
	
	public function testToString_ZERO() {
		var e:String = '0';
		var a:String = ASCII.ZERO;
		Assert.equals(e, a);
	}
	
	public function testValue_z() {
		Assert.equals(122, ASCII.z);
	}
	
	public function testToString_z() {
		var e:String = 'z';
		var a:String = ASCII.z;
		Assert.equals(e, a);
	}
	
	public function testValue_Z() {
		Assert.equals(90, ASCII.Z);
	}
	
	public function testToString_Z() {
		var e:String = 'Z';
		var a:String = ASCII.Z;
		Assert.equals(e, a);
	}
	
}