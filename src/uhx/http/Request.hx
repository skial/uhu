package uhx.http;

#if js
import js.html.XMLHttpRequest;
#else
import haxe.Http;
#end

import haxe.PosInfos;
import taurine.io.Uri;
import haxe.ds.StringMap;
import uhx.http.Response;
import uhx.http.impl.t.TData;
import uhx.http.impl.e.EMethod;
import uhx.http.impl.a.Headers;

using StringTools;
using haxe.EnumTools;

/**
 * ...
 * @author Skial Bainn
 */
@:allow(uhx.http.Response)
class Request implements Klas {
	
	#if js
	private var xhr:XMLHttpRequest;
	#else
	private var http:Http;
	#end
	
	public var headers:Headers;
	public var response:Response;
	
	public var url(default, null):Uri;
	public var method(default, null):EMethod;
	
	private var callback:Void->Void;

	public function new(url:Uri, method:EMethod) {
		this.url = url;
		this.method = method;
		
		#if js
		xhr = new XMLHttpRequest();
		headers = xhr;
		#end
		
		init();
	}
	
	private function init() {
		callback = function() { };
		#if js
		xhr.open( method.getName(), url.toString(), true );
		xhr.onload = onLoad;
		#end
	}
	
	public function destroy() {
		#if js
		xhr.abort();
		#end
	}
	
	public function send(cb:Void->Void, ?params:StringMap<String>, ?data:String = ''):Void {
		callback = cb;
		
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
						data += key.urlEncode() + '=' + params.get( key ).urlEncode();
					}
					
					headers.set('content-type', 'application/x-www-form-urlencoded');
					
				case _:
			}
			
		}
		
		xhr.send( data );
	}
	
	private function onLoad(e) {
		response = new Response( this );
		callback();
	}
	
}