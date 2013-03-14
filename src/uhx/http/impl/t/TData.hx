package uhx.http.impl.t;

import haxe.io.Bytes;
import haxe.ds.StringMap;

/**
 * @author Skial Bainn
 */

typedef TData = {
	
	@:optional var files:Array<Bytes>;
	@:optional var headers:StringMap<String>;
	
}