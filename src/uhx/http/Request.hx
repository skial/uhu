package uhx.http;

import uhx.web.URI;
import haxe.PosInfos;
import haxe.ds.StringMap;
import uhx.http.Response;
import uhx.http.impl.t.TData;
import js.html.XMLHttpRequest;
import uhx.http.impl.e.EMethod;
import uhx.http.impl.a.Headers;

using StringTools;
using haxe.EnumTools;

/**
 * ...
 * @author Skial Bainn
 */
class Request implements Klas {
	
	#if js
	@:noCompletion public var xhr:XMLHttpRequest;
	#end
	
	public var headers:Headers;
	
	@:pub public var error:Response;
	@:pub public var success:Response;
	
	public var url(default, null):URI;
	public var method(default, null):EMethod;

	public function new(url:URI, method:EMethod, ?p:PosInfos) {
		this.url = url;
		this.method = method;
		
		#if js
		xhr = new XMLHttpRequest();
		headers = xhr;
		#end
		
		init();
	}
	
	private function init() {
		#if js
		xhr.open( method.getName(), url.toString(), true );
		
		xhr.addEventListener('load', onSuccess, false);
		xhr.addEventListener('error', onError, false);
		#end
	}
	
	public function destroy() {
		#if js
		xhr.abort();
		
		xhr.removeEventListener('load', onSuccess, false);
		xhr.removeEventListener('error', onError, false);
		#end
	}
	
	public function send(?params:StringMap<String>, ?body:String = ''):Void {
		
		if (params != null) {
			
			switch (method) {
				case GET:
					for (key in params.keys()) {
						url.query.set( key, [ params.get( key ) ] );
					}
					
					destroy();
					init();
					
				case POST:
					for (key in params.keys()) {
						body += key.urlEncode() + '=' + params.get( key ).urlEncode();
					}
					
					headers.set('content-type', 'application/x-www-form-urlencoded');
					
				case _:
			}
			
		}
		
		xhr.send( body );
	}
	
	private function onSuccess(e) {
		var response = new Response( this );
		success = response;
	}
	
	private function onError(e) {
		var response = new Response( this );
		error = response;
	}
	
}