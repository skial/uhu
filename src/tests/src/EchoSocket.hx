package ;
import haxe.io.Eof;
import haxe.io.Error;
import sys.net.Host;
import sys.net.Socket;

/**
 * @author Skial Bainn
 */

class EchoSocket {
	
	public static function main() {
		
		var server = new Socket();
		var host = new Host('127.0.0.1');
		
		server.bind(host, 8248);
		server.listen(1);
		var l = '';
		while( true ) {
			var c = server.accept();
            c.setBlocking(false);
			try {
				l = c.input.readLine();
				trace(l);
				c.output.writeString('ECHO : ' + l);
				c.close();
			} catch (e:Dynamic) {
				c.close();
			}
        }
		
		//server.close();
		
		
	}
	
}