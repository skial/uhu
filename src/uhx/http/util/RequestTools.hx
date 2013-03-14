package uhx.http.util;
import js.html.XMLHttpRequest;
import uhx.http.impl.i.IRequestUtil;
import uhx.http.impl.t.TData;
import uhx.http.Method;

/**
 * ...
 * @author Skial Bainn
 */

class RequestTools {

	public static function applyPayload(request:IRequestUtil, payload:TData) {
		if (payload.headers != null) {
			
			for (key in payload.headers.keys()) {
				request.addHeader( key, payload.headers.get( key ) );
			}
			
		}
	}
	
}