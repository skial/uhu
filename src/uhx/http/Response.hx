package uhx.http;

/**
 * ...
 * @author Skial Bainn
 */

#if display
typedef Response = uhx.http.impl.t.TResponse;
#elseif sys
typedef Response = uhx.http.impl.Response_sys;
#else
typedef Response = uhx.http.impl.Response_js;
#end