package uhx.oauth;

import uhx.oauth.spec2_0.Client;
import uhx.oauth.spec2_0.i.IRequest;

using StringTools;
using haxe.EnumTools;
using uhx.web.URLs;

/**
 * ...
 * @author Skial Bainn
 */

/**
 * http://developer.github.com/v3/oauth/
 */
class Github {
	
	public var client(default, null):Client;
	public var scopes(default, null):Array<GithubScopes>;
	public var request(default, null):IRequest;
	
	public var onSuccess:String->Void;
	public var onError:String->Void;

	public function new() {
		scopes = new Array<GithubScopes>();
		client = new Client();
		client.scope_separator = ',';
		
		client.url.auth = 'https://github.com/login/oauth/authorize'.toURL();
		client.url.access = 'https://github.com/login/oauth/access_token'.toURL();
	}
	
	public function getAccess() {
		request = client.makeRequest( client.url.auth );
		
		if (onSuccess != null) request.http.onData = onSuccess;
		if (onError != null) request.http.onError = onError;
		
		request.http.request( false );
	}
	
}

/**
 * http://developer.github.com/v3/oauth/#scopes
 */
enum GithubScopes {
	//None;
	User;
	UserEmail;
	UserFollow;
	Public_Repo;
	Repo;
	RepoStatus;
	Delete_Repo;
	Notifications;
	Gist;
}