package uhx.http.impl;

import uhx.core.Klas;
import uhx.http.impl.t.TRequest;
import uhx.web.URI;
import msignal.Signal;
import uhx.http.Method;
import uhx.http.Response;
import haxe.ds.StringMap;
import uhx.http.impl.t.TData;
import js.html.XMLHttpRequest;
import uhx.http.impl.i.IRequest;
import uhx.http.impl.i.IResponse;
import uhx.http.impl.i.IRequestUtil;

using haxe.EnumTools;
using uhx.http.util.RequestTools;

/**
 * ...
 * @author Skial Bainn
 */

@:implements(TRequest)
class Request_js implements IRequest implements Klas {
	
	@:noCompletion public var xhr:XMLHttpRequest;
	public var headers(default, null):StringMap<String>;
	
	public var onError:Signal1<IResponse>;
	public var onSuccess:Signal1<IResponse>;

	public function new(url:URI, method:Method) {
		xhr = new XMLHttpRequest();
		headers = new StringMap<String>();
		
		onError = new Signal1<IResponse>();
		onSuccess = new Signal1<IResponse>();
		
		xhr.addEventListener('load', function(e) {
			var response = new Response( this );
			onSuccess.dispatch( response );
		}, false);
		
		xhr.addEventListener('error', function(e) {
			var response = new Response( this );
			onError.dispatch( response );
		}, false);
		
		xhr.open( method.getName(), url.toString(), true );
	}
	
	public function init():Void {
		for (key in headers.keys()) {
			xhr.setRequestHeader( key, headers.get( key ) );
		}
	}
	
	public function send():Void {
		xhr.send();
	}
	
}