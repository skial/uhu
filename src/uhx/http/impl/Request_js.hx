package uhx.http.impl;

import uhx.web.URI;
import uhx.http.Response;
import haxe.ds.StringMap;
import uhx.http.impl.t.TData;
import js.html.XMLHttpRequest;
import uhx.http.impl.e.EMethod;
import thx.react.Signal;

using haxe.EnumTools;

/**
 * ...
 * @author Skial Bainn
 */

class Request_js implements Klas {
	
	@:noCompletion public var xhr:XMLHttpRequest;
	public var headers(default, null):StringMap<String>;
	
	public var onError:Signal1<Response>;
	public var onSuccess:Signal1<Response>;

	public function new(url:URI, method:EMethod) {
		xhr = new XMLHttpRequest();
		headers = new StringMap<String>();
		
		onError = new Signal1<Response>();
		onSuccess = new Signal1<Response>();
		
		xhr.addEventListener('load', function(e) {
			var response = new Response( this );
			onSuccess.trigger( response );
		}, false);
		
		xhr.addEventListener('error', function(e) {
			var response = new Response( this );
			onError.trigger( response );
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