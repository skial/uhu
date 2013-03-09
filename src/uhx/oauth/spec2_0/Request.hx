package uhx.oauth.spec2_0;

import haxe.ds.StringMap;
import haxe.Http;
import uhx.util.URLParser;
import uhx.oauth.spec2_0.e.EGrant;
import uhx.oauth.spec2_0.i.IRequest;

/**
 * ...
 * @author Skial Bainn
 */
class Request implements IRequest {
	
	public var type:EGrant;
	public var params:StringMap<String>;
	public var http(default, null):Http;
	public var url(default, set):URLParser;

	public function new() {
		params = new StringMap<String>();
	}
	
	public function add(key:String, value:String):Void {
		params.set( key, value );
	}
	
	public function request():Void {
		var data:String;
		var post:Bool = false;
		
		switch ( type ) {
			case Authorization_Code:
				
			case Implicit:
				
			case Password:
				
			case Client_Credentials:
				
			case Extension(_):
				
		}
		
		http.request( post );
	}
	
	public function set_url(value:URLParser):URLParser {
		url = value;
		http = new Http( value.toString() );
		return value;
	}
	
}