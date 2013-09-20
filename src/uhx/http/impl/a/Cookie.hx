package uhx.http.impl.a;

import taurine.io.QueryString;
import taurine.io.Uri;
import haxe.ds.StringMap;

using StringTools;

/**
 * ...
 * @author Skial Bainn
 */
abstract Cookie(CookieData) {
	
	public inline function new(v:CookieData) {
		this = v;
	}
	
	@:to public inline function toString():String return this.toString();
	
	@:arrayAccess public inline function writeString(key:String, value:String):String {
		switch(key.toLowerCase()) {
			case 'name', 'key': this.name = value;
			case 'value': this.value = value;
			case 'path': this.path = value;
			case 'domain', 'url': this.domain = new Uri( value );
			case 'expires', 'date': this.expires = value;
			case _: value;
		}
		return value;
	}
	
	@:arrayAccess public inline function writeBool(key:String, value:Bool):Bool {
		return switch(key.toLowerCase()) {
			case 'secure', 'https': this.secure = value;
			case 'http', 'httponly': this.httpOnly = value;
			case _: value;
		}
	}
	
	@:arrayAccess public inline function read(key:String):Dynamic {
		return switch(key.toLowerCase()) {
			case 'name', 'key': this.name;
			case 'value': this.value;
			case 'path': this.path;
			case 'domain', 'url': this.domain.toString();
			case 'expires', 'date': this.expires;
			case 'secure', 'https': this.secure;
			case 'http', 'httponly': this.httpOnly;
			case _: '';
		}
	}
	
	@:from public static inline function fromString(v:String):Cookie {
		var values = QueryString.parse( v, ';' );
		for (key in values.keys()) {
			trace( key );
		}
		return new Cookie( new CookieData() );
	}
	
}

class CookieData {
	
	public var name:String = null;
	public var value:String = null;
	public var expires:String = null;
	public var path:String = null;
	public var domain:Uri = null;
	public var httpOnly:Bool = false;
	public var secure:Bool = false;
	
	public function new() {
		// om nom nom
	}
	
	public function toString() {
		var result = '';
		
		if (name != null && value != null) {
			
			result = '$name=$value';
			if (expires != null) result += ' ;expires=$expires';
			if (domain != null) result += ' ;domain=${domain.toString()}';
			if (path != null) result += ' ;path=$path';
			if (httpOnly) result += ' ;HttpOnly';
			if (secure) result += ' ;Secure';
			if (!result.endsWith(';')) result += '; ';
			
		}
		
		return result;
	}
	
}