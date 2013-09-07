package uhx.http;

import haxe.Json;
import haxe.Timer;
import utest.Assert;
import uhx.http.impl.e.EStatus;
import uhx.http.impl.e.EMethod;
import uhx.http.impl.i.IResponse;

using uhx.web.URL;

/**
 * ...
 * @author Skial Bainn
 */

class RequestSpec implements Klas {
	
	/**
	 * All url's have to accept cross origin requests, which is required
	 * by Javascript, so the tests have a chance to succeed. 
	 * \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
	 * 		Start a local server you idiot.
	 * 			nekotools server -p 80
	 * / / / / / / / / / / / / / / / / / / / / /
	 */
	
	public static inline var DELAY:Int = 1000;
	
	public var request:Request;
	public var response:Response;
	
	@:sub(this.request.error)
	public var error:Response;
	
	@:sub(this.request.success)
	public var success:Response;
	
	public function new() {
		
	}
	
	public function testGET() {
		var url = 'http://ip.jsontest.com';
		request = new Request( url.toURL(), GET );
		request.send();
		
		@:wait Timer.delay( Assert.createAsync( [], DELAY ), DELAY );
		
		Assert.equals( 200, request.success.status_code );
		Assert.isTrue( request.success.headers.exists('Content-Type') );
		Assert.isTrue( request.success.headers.exists('content-type') );
		Assert.equals( url, request.success.url.toString() );
		Assert.equals( EStatus.OK, request.success.status );
	}
	
	public function testPOST_StringMap() {
		var url = 'https://posttestserver.com/post.php';
		request = new Request( url.toURL(), POST );
		request.send( ['Name' => 'Skial'] );
		
		@:wait Timer.delay( Assert.createAsync( [], DELAY ), DELAY );
		
		Assert.equals( 200, request.success.status_code );
		Assert.equals( EStatus.OK, request.success.status );
		Assert.equals( url, request.success.url.toString() );
	}
	
	public function testHeaders() {
		var url = 'http://headers.jsontest.com/';
		request = new Request( url.toURL(), GET );
		request.send();
		
		@:wait Timer.delay( Assert.createAsync( [], DELAY ), DELAY );
		
		var json = Json.parse( request.success.text );
		
		Assert.equals( 200, request.success.status_code );
		Assert.equals( EStatus.OK, request.success.status );
		Assert.stringContains( 'localhost', json.Origin );
		Assert.stringContains( 'headers.jsontest.com', json.Host );
	}
	
}