package uhx.http.impl.i;

import uhx.web.URI;
import msignal.Signal;
import uhx.http.Method;
import haxe.ds.StringMap;
import uhx.http.impl.t.TData;
import uhx.http.impl.i.IResponse;

/**
 * ...
 * @author Skial Bainn
 */
extern class ERequest {

	public var onError:Signal1<IResponse>;
	public var onSuccess:Signal1<IResponse>;
	public var headers(default, null):StringMap<String>;
	
	public function new(url:URI, method:Method);
	public function send():Void;
	
}