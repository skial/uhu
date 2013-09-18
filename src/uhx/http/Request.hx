package uhx.http;

import haxe.PosInfos;
import taurine.io.Uri;
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
	
	/*public var error:Response;
	public var success:Response;*/
	public var response:Response;
	
	public var url(default, null):Uri;
	public var method(default, null):EMethod;
	
	@:noCompletion public var cb:Void->Void;

	public function new(url:Uri, method:EMethod) {
		this.url = url;
		this.method = method;
		
		#if js
		xhr = new XMLHttpRequest();
		headers = xhr;
		cb = function() { };
		#end
		
		init();
	}
	
	private function init() {
		#if js
		xhr.open( method.getName(), url.toString(), true );
		xhr.onload = onLoad;
		/*xhr.addEventListener('load', onSuccess, false);
		xhr.addEventListener('error', onError, false);*/
		#end
	}
	
	public function destroy() {
		#if js
		xhr.abort();
		/*xhr.removeEventListener('load', onSuccess, false);
		xhr.removeEventListener('error', onError, false);*/
		#end
	}
	
	public function send(cb:Void->Void, ?params:StringMap<String>, ?body:String = ''):Void {
		this.cb = cb;
		
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
	
	private function onLoad(e) {
		response = new Response( this );
		cb();
	}
	
	/*private function onSuccess(e) {
		var response = new Response( this );
		success = response;
	}
	
	private function onError(e) {
		var response = new Response( this );
		error = response;
	}*/
	
}