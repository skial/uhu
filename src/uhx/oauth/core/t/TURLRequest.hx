package uhx.oauth.core.t;

/**
 * ...
 * @author Skial Bainn
 */

typedef TURLRequest = {
	var request:String;	//	used to obtain an unauthorized request token
	var auth:String;	//	used to obtain user authorization for consumer access
	var access:String;	//	used to exchange user request token for access token
}