package uhx.http.impl;

import uhx.web.URI;
import haxe.io.Bytes;
import uhx.core.Klas;
import uhx.http.Request;
import haxe.ds.StringMap;
import js.html.XMLHttpRequest;
import uhx.http.impl.e.EStatus;
import uhx.http.impl.t.TRequest;
import uhx.http.impl.i.IRequest;
import uhx.http.impl.t.TResponse;
import uhx.http.impl.i.IResponse;

/**
 * ...
 * @author Skial Bainn
 */

@:implements(TResponse)
class Response_js implements Klas/* implements IResponse*/ {
	
	public var request(default, null):Request;
	public var url(get, null):URI;
	public var text(get, null):String;
	public var status(get, null):EStatus;
	public var content(get, null):Bytes;
	public var encoding(get, null):String;
	public var status_code(get, null):Int;
	public var history(get, null):Array<String>;
	public var headers(get, null):StringMap<String>;
	
	@:noCompletion public var xhr:XMLHttpRequest;

	public function new(r:Request) {
		request = r;
		
		xhr = untyped request.xhr;
	}
	
	private function get_url():URI {
		return new URI('');
	}
	
	private function get_text():String {
		return xhr.responseText;
	}
	
	private function get_status():EStatus {
		return OK;
	}
	
	private function get_content():Bytes {
		return Bytes.ofString( '' );
	}
	
	private function get_encoding():String {
		return '';
	}
	
	private function get_status_code():Int {
		return xhr.status;
	}
	
	private function get_history():Array<String> {
		return [''];
	}
	
	private function get_headers():StringMap<String> {
		return new StringMap<String>();
	}
	
}