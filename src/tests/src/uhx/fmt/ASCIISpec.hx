package uhx.fmt;

import haxe.unit.TestCase;

/**
 * ...
 * @author Skial Bainn
 */
class ASCIISpec extends TestCase {

	public function new() {
		super();
	}
	
	public function testValue_NUL() {
		assertEquals(0, ASCII.NUL);
	}
	
	public function testValue_NUL_alias() {
		assertEquals(0, ASCII.NULL);
	}
	
	public function testToString_NUL() {
		assertEquals('\\0', ASCII.NUL);
	}
	
	public function testToString_NUL_alias() {
		assertEquals('\\0', ASCII.NULL);
	}
	
	public function testValue_ZERO() {
		assertEquals(48, ASCII.ZERO);
	}
	
	public function testToString_ZERO() {
		assertEquals('0', '' + ASCII.ZERO);
	}
	
	public function testValue_z() {
		assertEquals(122, ASCII.z);
	}
	
	public function testToString_z() {
		assertEquals('z', ASCII.z);
	}
	
	public function testValue_Z() {
		assertEquals(90, ASCII.Z);
	}
	
	public function testToString_Z() {
		assertEquals('Z', ASCII.Z);
	}
	
}