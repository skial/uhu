package uhx.http;

/**
 * ...
 * @author Skial Bainn
 */
import haxe.io.Bytes;
import haxe.rtti.Meta;
import taurine.io.Uri;
import uhx.http.Request;
import haxe.ds.StringMap;
import uhx.http.impl.Status;
import js.html.XMLHttpRequest;
import uhx.http.impl.e.EStatus;
import uhx.http.impl.a.Headers;

/**
 * ...
 * @author Skial Bainn
 */

class Response implements Klas {
	
	public var request(default, null):Request;
	public var url(get, null):Uri;
	public var text(get, null):String;
	public var status(get, null):EStatus;
	public var content(get, null):Bytes;
	//public var encoding(get, null):String;
	public var status_code(get, null):Int;
	public var history(get, null):Array<String>;
	public var headers(default, null):Headers;
	
	private var xhr:XMLHttpRequest;
	
	public function new(r:Request) {
		request = r;
		
		#if js
		xhr = request.xhr;
		headers = xhr;
		#else
		
		#end
	}
	
	private inline function get_url():Uri {
		return request.url;
	}
	
	private inline function get_text():String {
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
	
	private inline function get_status_code():Int {
		return xhr.status;
	}
	
	private function get_history():Array<String> {
		return [''];
	}
	
}