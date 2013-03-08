package sys.net;
import haxe.unit.TestCase;
import haxe.io.Eof;
import sys.io.Process;
import sys.net.Socket;
import sys.net.Host;

/**
 * ...
 * @author Skial Bainn
 */
class HostSpec extends TestCase {

	public function new() {
		super();
	}
	
	public function testIPAddress() {
		var h = new Host('haxe.org');
		assertEquals('5.39.76.185', '' + h.toString());
	}
	
	public function testHostAddress() {
		var h = new Host('5.39.76.185');
		assertEquals('ks3261879.kimsufi.com', '' + h.reverse());
	}
	
}