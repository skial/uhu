package uhx.http.impl.t;

import uhx.web.URI;
import msignal.Signal;
import uhx.http.Method;
import haxe.ds.StringMap;
import uhx.http.impl.t.TData;
import uhx.http.impl.i.IResponse;

/**
 * @author Skial Bainn
 */

typedef TRequest = {
	var onError:Signal1<TResponse>;
	var onSuccess:Signal1<TResponse>;
	var headers(default, null):StringMap<String>;
	
	function new(url:URI, method:Method):TRequest;
	function send():Void;
}