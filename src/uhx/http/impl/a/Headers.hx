package uhx.http.impl.a;

private typedef PlatformHeaders = 
#if js
js.html.XMLHttpRequest;
#else
haxe.Http;
#end

/**
 * ...
 * @author Skial Bainn
 * http://stackoverflow.com/questions/7462968/restrictions-of-xmlhttprequests-getresponseheader
 */
@:access(haxe.Http)
abstract Headers(PlatformHeaders) from PlatformHeaders to PlatformHeaders {

	public inline function new(v:PlatformHeaders) {
		this = v;
	}
	
	public inline function get(key:String):String {
		#if js
		return this.getResponseHeader( key );
		#else
		return this.headers.get( key );
		#end
	}
	
	public inline function exists(key:String):Bool {
		#if js
		return this.getResponseHeader( key ) != null;
		#else
		return this.headers.exists( key );
		#end
	}
	
	public inline function set(key:String, value:String):Void {
		#if js
		this.setRequestHeader( key, value );
		#else
		this.headers.set( key, value );
		#end
	}
	
}