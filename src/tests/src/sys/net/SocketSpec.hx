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
class SocketSpec extends TestCase {

	public function new() {
		super();
	}
	
	public function testLocalhost() {
		var process = new Process('neko', ['bin/echosocket.n']);
		
		Sys.sleep(0.2);		//	allow the other process to start
		
		var client = new Socket();
		var host = new Host('127.0.0.1');
		var v = 'Hello Echo 1';
		var e = '';
		
		client.connect(host, 8248);
		client.output.writeString(v + '\n');	// who would have known, newline WAS needed. Idiot.
		e = client.read();
		client.close();
		
		Sys.sleep(0.2);		//	allow echo socket to recover ;)
		
		try {
			process.kill();
		} catch (e:Dynamic) {
			process.close();
		}
		
		// If you dont prefix e with '' then it fails to match???
		assertEquals('ECHO : Hello Echo 1', '' + e);
	}
	
}