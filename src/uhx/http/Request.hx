package uhx.http;

/**
 * ...
 * @author Skial Bainn
 */

#if sys
typedef Request = uhx.http.impl.Request_sys;
#else
typedef Request = uhx.http.impl.Request_js;
#end
//typedef Request = haxe.macro.MacroType<[Protocol.define()]>;