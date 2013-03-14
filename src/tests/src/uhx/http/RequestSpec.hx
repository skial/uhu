package uhx.http;

import haxe.unit.TestCase;
import uhx.http.impl.i.IResponse;
import uhx.http.Method;

using uhx.web.URL;

/**
 * ...
 * @author Skial Bainn
 */

class RequestSpec extends TestCase {

	public var request:Request;
	public var response:Response;
	
	public function new() {
		super();
	}
	
	override public function setup():Void {
		
	}
	
	public function testGET() {
		request = new Request( 'https://api.github.com/users/skial'.toURL(), GET );
		request.init();
		
		request.onSuccess.add( GET_onSuccess );
		request.onError.add( GET_onError );
		
		request.send();
	}
	
	public function GET_onSuccess(r:IResponse) {
		trace('SUCCESS!');
		trace(r.status_code);
		trace(r.text);
	}
	
	public function GET_onError(r:IResponse) {
		trace('ERROR!');
		trace(r.status_code);
		trace(r.text);
	}
	
}