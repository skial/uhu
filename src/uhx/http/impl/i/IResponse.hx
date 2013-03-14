package uhx.http.impl.i;

import uhx.web.URI;
import haxe.io.Bytes;
import uhx.http.Status;
import haxe.ds.StringMap;


/**
 * @author Skial Bainn
 */

interface IResponse {
	
	public var request(default, null):IRequest;
	public var url(get, null):URI;
	public var text(get, null):String;
	public var status(get, null):Status;
	public var content(get, null):Bytes;
	public var encoding(get, null):String;
	public var status_code(get, null):Int;
	public var history(get, null):Array<String>;
	public var headers(get, null):StringMap<String>;
	
	private function get_url():URI;
	private function get_text():String;
	private function get_status():Status;
	private function get_content():Bytes;
	private function get_encoding():String;
	private function get_status_code():Int;
	private function get_history():Array<String>;
	private function get_headers():StringMap<String>;
	
}