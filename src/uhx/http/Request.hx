package uhx.http;

/**
 * ...
 * @author Skial Bainn
 */

#if display
typedef Request = uhx.http.impl.t.TRequest;
#elseif sys
typedef Request = uhx.http.impl.Request_sys;
#else
typedef Request = uhx.http.impl.Request_js;
#end