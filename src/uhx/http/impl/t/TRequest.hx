package uhx.http.impl.t;

import uhx.web.URI;
import msignal.Signal;
import haxe.ds.StringMap;
import uhx.http.impl.t.TData;
import uhx.http.impl.e.EMethod;
import uhx.http.impl.i.IResponse;

/**
 * @author Skial Bainn
 */

typedef TRequest = {
	public var onError:Signal1<TResponse>;
	public var onSuccess:Signal1<TResponse>;
	public var headers(default, null):StringMap<String>;
	
	public function new(url:URI, method:EMethod):TRequest;
	public function init():Void;
	public function send():Void;
}