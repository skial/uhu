package uhx.util.i;

import haxe.ds.StringMap;

/**
 * @author Skial Bainn
 */

/**
 URLParser.hx
 -----
 
 Simple example :
 ```
 "http://user:pass@www.haxe.org/manual?a=1#fragment"
 "scheme://username:password@hostname/path?queries#fragment"
 ```
 
 Should add `directory`, `file` and `relative` fields.
 */
interface IURLParser {
	
	/**
	 * example - `http` of `http://www.test.com`
	 */
	public var scheme(get_scheme, set_scheme):String;
	
	/**
	 * example - `user` of `user:pass@www.test.com`
	 */
	public var username(get_username, set_username):String;
	
	/**
	 * example - `pass` of `user:pass@www.test.com`
	 */
	public var password(get_password, set_password):String;
	
	/**
	 * example - `www.test.com` of `http://www.test.com`
	 */
	public var hostname(get_hostname, set_hostname):String;
	
	/**
	 * example - `8080`
	 */
	public var port(get_port, set_port):String;
	
	/**
	 * example - `/path/to/file.html` of `www.test.com/path/to/file.html`
	 */
	public var path(get_path, set_path):String;
	
	/**
	 * contains parameters in a Hash - example - `test.com?q=books` = `query.get('q');` // equals 'books'
	 */
	public var query(default, default):StringMap<Array<String>>;
	
	/**
	 * example - `fragment` of `www.test.com#fragment`
	 */
	public var fragment(get_fragment, set_fragment):String;

	public function toString():String;
	private function get_scheme():String;
	private function set_scheme(value:String):String;
	private function get_username():String;
	private function set_username(value:String):String;
	private function get_password():String;
	private function set_password(value:String):String;
	private function get_hostname():String;
	private function set_hostname(value:String):String;
	private function get_port():String;
	private function set_port(value:String):String;
	private function get_path():String;
	private function set_path(value:String):String;
	private function get_fragment():String;
	private function set_fragment(value:String):String;
	
}