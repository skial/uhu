package uhx.http;

#if js
import js.Browser;
import js.html.XMLHttpRequest;
import js.Lib;
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
import uhx.http.impl.a.Cookie;

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
	private var status:Int = 0;
	#end
	
	public var headers:Headers;
	public var response:Response;
	public var cookies:Array<Cookie>;
	
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
		cookies = new Array<Cookie>();
		#if js
		xhr.open( method.getName(), url.toString(), true );
		xhr.onload = onLoad;
		#else
		http = new Http( url.toString() );
		http.onData = onLoad;
		http.onStatus = onStatus;
		headers = http;
		#end
	}
	
	private function onLoad(e) {
		response = new Response( this );
		callback();
	}
	
	#if !js
	private function onStatus(s) {
		status = s;
	}
	#end
	
	private function prepare() {
		for (cookie in cookies) {
			#if js
			Browser.document.cookie = cookie;
			#else
			this.headers.set('Set-Cookie', cookie);
			#end
		}
	}
	
	public function destroy() {
		#if js
		xhr.abort();
		#else
		http = null;
		#end
	}
	
	public function send(cb:Void->Void, ?params:StringMap<String>, ?data:String = ''):Void {
		prepare();
		
		callback = cb;
		
		if (params != null) {
			
			switch (method) {
				case GET:
					for (key in params.keys()) {
						url.query.set( key, [ params.get( key ) ] );
					}
					
					destroy();
					init();
					prepare();
					
				case POST:
					for (key in params.keys()) {
						data += key.urlEncode() + '=' + params.get( key ).urlEncode();
					}
					
					headers.set('content-type', 'application/x-www-form-urlencoded');
					
					#if !js
					http.setPostData( data );
					#end
					
				case _:
			}
			
		}
		
		#if js
		xhr.send( data );
		#else
		http.request( method == POST ? true : false );
		#end
	}
	
}