package uhx.http;

import haxe.Json;
import haxe.Timer;
import utest.Assert;
import uhx.http.impl.e.EStatus;
import uhx.http.impl.e.EMethod;
import taurine.io.Uri;
import uhx.http.Message;

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
	
	public var request:Request;
	//public var response:Response;
	
	public function new() {
		
	}
	
	public function testGET() {
		var url = 'http://ip.jsontest.com';
		request = new Request( new Uri( url ), GET );
		
		@:wait request.send( Assert.createAsync( [], 1000 ) );
		
		Assert.equals( 200, request.response.status_code );
		Assert.isTrue( request.response.headers.exists('Content-Type') );
		Assert.isTrue( request.response.headers.exists('content-type') );
		Assert.equals( url, request.response.url.toString() );
		Assert.equals( EStatus.OK, request.response.status );
	}
	
	public function testPOST_StringMap() {
		var url = 'http://posttestserver.com/post.php';
		request = new Request( new Uri( url ), POST );
		
		@:wait request.send( Assert.createAsync( [], 1000 ) );
		
		Assert.equals( 200, request.response.status_code );
		Assert.equals( EStatus.OK, request.response.status );
		Assert.equals( url, request.response.url.toString() );
	}
	
	public function testHeaders() {
		trace( uhx.http.impl.Rules.OCTET( 'skial' ) );
		var url = 'http://headers.jsontest.com/';
		request = new Request( new Uri( url ), GET );
		request.headers.set( 'content-type', 'application/json' );
		
		@:wait request.send( Assert.createAsync( [], 1000 ) );
		
		var json = Json.parse( request.response.text );
		trace( json );
		Assert.equals( 200, request.response.status_code );
		Assert.equals( EStatus.OK, request.response.status );
		Assert.stringContains( 'localhost', json.Origin );
		Assert.stringContains( 'headers.jsontest.com', json.Host );
		Assert.equals( 'application/json', Reflect.field( json, 'Content-Type' ) );
	}
	
}