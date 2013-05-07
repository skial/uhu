package uhx.http.impl.t;

import uhx.web.URI;
import haxe.io.Bytes;
import haxe.ds.StringMap;
import uhx.http.impl.e.EStatus;

/**
 * ...
 * @author Skial Bainn
 */
typedef TResponse = {

	public var request(default, null):TRequest;
	public var url(get, null):URI;
	public var text(get, null):String;
	public var status(get, null):EStatus;
	public var content(get, null):Bytes;
	public var encoding(get, null):String;
	public var status_code(get, null):Int;
	public var history(get, null):Array<String>;
	public var headers(get, null):StringMap<String>;
	
	public function new(r:TRequest):TResponse;
	private function get_url():URI;
	private function get_text():String;
	private function get_status():EStatus;
	private function get_content():Bytes;
	private function get_encoding():String;
	private function get_status_code():Int;
	private function get_history():Array<String>;
	private function get_headers():StringMap<String>;
	
}