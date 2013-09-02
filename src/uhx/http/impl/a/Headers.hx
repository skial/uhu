package uhx.http.impl.a;

import js.html.XMLHttpRequest;

/**
 * ...
 * @author Skial Bainn
 * http://stackoverflow.com/questions/7462968/restrictions-of-xmlhttprequests-getresponseheader
 */
abstract Headers(XMLHttpRequest) from XMLHttpRequest to XMLHttpRequest {

	public inline function new(v:XMLHttpRequest) {
		this = v;
	}
	
	public inline function get(key:String):String {
		return this.getResponseHeader( key );
	}
	
	public inline function exists(key:String):Bool {
		return this.getResponseHeader( key ) != null;
	}
	
	public inline function set(key:String, value:String):Void {
		this.setRequestHeader( key, value );
	}
	
}