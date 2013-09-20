package uhx.http.impl.a;
import haxe.ds.StringMap.StringMap;

/**
 * ...
 * @author Skial Bainn
 */
abstract Cookies(Array<Cookie>) from Array<Cookie> to Array<Cookie> {

	public inline function new(v) {
		this = v;
	}
	
	@:arrayAccess public inline function set(key:String, value:String):Cookie {
		var _cookie:Cookie = '$key=$value';
		this.push( _cookie );
		return _cookie;
	}
	
	@:from public static inline function fromStringMap(v:StringMap<String>):Cookies {
		var cookie_jar:Array<Cookie> = [];
		for (key in v.keys()) {
			cookie_jar.push( '$key=${v.get(key)}' );
		}
		return new Cookies( cookie_jar );
	}
	
}