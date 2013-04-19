package uhx.http.impl;

import haxe.Http;
import uhx.web.URI;
import msignal.Signal;
import uhx.http.Method;
import haxe.ds.StringMap;
import uhx.http.impl.t.TData;
import uhx.http.impl.t.TRequest;
import uhx.http.impl.t.TResponse;

/**
 * ...
 * @author Skial Bainn
 */

@:implements(TRequest)
class Request_sys implements Klas {
	
	public var onError:Signal1<TResponse>;
	public var onSuccess:Signal1<TResponse>;
	public var headers(default, null):StringMap<String>;

	public function new(url:URI, method:Method) {
		
	}
	
	public function init():Void {
		
	}
	
	public function send():Void {
		
	}
	
}