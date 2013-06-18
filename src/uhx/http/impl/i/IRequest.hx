package uhx.http.impl.i;

import thx.react.Signal;
import uhx.web.URI;
import haxe.ds.StringMap;
import uhx.http.impl.t.TData;
import uhx.http.impl.i.IResponse;

/**
 * @author Skial Bainn
 */

interface IRequest {
	
	public var onError:Signal1<IResponse>;
	public var onSuccess:Signal1<IResponse>;
	public var headers(default, null):StringMap<String>;
	
	public function send():Void;
	
}