package uhx.http;

/**
 * ...
 * @author Skial Bainn
 */

#if sys
typedef Response = uhx.http.impl.Response_sys;
#else
typedef Response = uhx.http.impl.Response_js;
#end
//typedef Response = haxe.macro.MacroType<[Protocol.define()]>;