package uhx.oauth.spec1_0a.i;

import haxe.Http;
import uhx.http.Method;
import haxe.ds.StringMap;
import uhx.util.URLParser;

/**
 * ...
 * @author Skial Bainn
 */

/**
 * OAuth Authentication is done in three steps:
 * - The Consumer obtains an unauthorized Request Token.
 * - The User authorizes the Request Token.
 * - The Consumer exchanges the Request Token for an Access Token.
 */
interface IRequest {
	
	public var http(default, null):Http;
	public var params(default, null):StringMap<String>;
	
	//	The url to send everything to
	public var url(default, set):URLParser;
	
	//	http://tools.ietf.org/html/rfc5849#section-3.4.1
	public var base(get, null):String;
	
	//	The http method to use - POST, GET etc all uppercase ... enum?
	public var method(default, null):Method;
	
	public function request():Void;
	public function add(key:String, value:String):Void;
	
	private function get_base():String;
	private function set_url(value:URLParser):URLParser;
	
}