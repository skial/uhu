package uhx.oauth;

import haxe.Json;
import haxe.unit.TestCase;
import uhx.oauth.Github;
import uhx.web.URL;

using uhu.Library;
using uhx.web.URL;

/**
 * ...
 * @author Skial Bainn
 */
class GithubSpec extends TestCase {
	
	var github:Github;

	public function new() {
		super();
	}
	
	override public function setup():Void {
		github = new Github();
		
		var json = Json.parse( 'bin/github.oauth.json'.loadTemplate() );
		
		github.client.id = json.client.id;
		github.client.secret = json.client.secret;
		
		// optional but recommended
		github.client.url.callback = 'http://localhost/bin/test.js.html'.toURL();
		
		github.onSuccess = function(d:String) {
			trace(d);
		}
		
		github.onError = function(e:String) {
			trace(e);
		}
		
		github.getAccess();
		trace( URL.location );
		
		
	}
	
	public function testGithub() {
		
	}
	
}