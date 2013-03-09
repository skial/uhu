package uhx.oauth.spec2_0.i;

import haxe.ds.StringMap;
import haxe.Http;
import uhx.util.URLParser;
import uhx.oauth.spec2_0.e.EGrant;

/**
 * @author Skial Bainn
 */

interface IRequest {
	
	public var http(default, null):Http;
	
	// The url to send everything to.
	public var url(default, set):URLParser;
	
	// What type of request to make.
	public var type:EGrant;
	
	public var params:StringMap<String>;
	
	public function request():Void;
	public function add(key:String, value:String):Void;
	
	public function set_url(value:URLParser):URLParser;
	
}