package uhx.http.impl;

import haxe.rtti.Meta;
import uhx.web.URI;
import haxe.io.Bytes;
import uhx.http.Request;
import haxe.ds.StringMap;
import js.html.XMLHttpRequest;
import uhx.http.impl.e.EStatus;
import uhx.http.impl.i.IRequest;
import uhx.http.impl.i.IResponse;
import uhx.http.impl.a.Headers;

/**
 * ...
 * @author Skial Bainn
 */

class Response_js implements Klas {
	
	public var request(default, null):Request;
	public var url(get, null):URI;
	public var text(get, null):String;
	public var status(get, null):EStatus;
	public var content(get, null):Bytes;
	//public var encoding(get, null):String;
	public var status_code(get, null):Int;
	public var history(get, null):Array<String>;
	public var headers(get, null):Headers;
	
	@:noCompletion public var xhr:XMLHttpRequest;

	public function new(r:Request) {
		request = r;
		
		xhr = untyped request.xhr;
		
		headers = new Headers( xhr );
	}
	
	private function get_url():URI {
		return request.url;
	}
	
	private function get_text():String {
		return xhr.responseText;
	}
	
	private function get_status():EStatus {
		return Status.fromInt.get( xhr.status );
	}
	
	private function get_content():Bytes {
		return Bytes.ofString( '' );
	}
	
	/*private function get_encoding():String {
		return '';
	}*/
	
	private function get_status_code():Int {
		return xhr.status;
	}
	
	private function get_history():Array<String> {
		return [''];
	}
	
	private function get_headers():Headers {
		return headers;
	}
	
}