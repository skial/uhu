package uhx.http;

import de.polygonal.core.fmt.ASCII;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import sys.net.Host;
import sys.net.Socket;

using de.polygonal.core.fmt.ASCII;

/**
 * ...
 * @author Skial Bainn
 */
@:require(sys)
class Server {

	public static function handle(socket:Socket) {
		socket.setBlocking( true );
		
		var pbyte = -1;	// previous byte
		var cbyte = 0;	// current byte
		
		var buf = new BytesBuffer();
		var len = 0;
		
		while ( true ) {
			cbyte = socket.input.readByte();
			
			switch ( [pbyte, cbyte] ) {
				case [_, _] if (cbyte.isPrintable() || cbyte == ASCII.SPACE):
					buf.addByte( cbyte );
					
				case [ASCII.CARRIAGERETURN, ASCII.NEWLINE]:
					continue;
					
				case [_, _]:
					break;
			}
			
			trace( cbyte );
			pbyte = cbyte;
			
			len++;
		}
		
		trace( buf.getBytes().toString() );
		
		socket.close();
	}
	
}