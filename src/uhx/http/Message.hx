package uhx.http;
import haxe.ds.StringMap;
import uhx.fmt.ASCII;

/**
 * ...
 * @author Skial Bainn
 */
class Message {

	public var headers:StringMap<String>;
	public var body:String;
	
	public function new(?message:String) {
		headers = new StringMap<String>();
		body = message == null ? '' : message;
	}
	
	public function toString():String {
		var result = '';
		
		for (key in headers.keys()) {
			result += '$key:${headers.get(key)}' + ASCII.CR + ASCII.LF;
		}
		
		result += ASCII.NUL;
		result += body;
		
		return result;
	}
	
}