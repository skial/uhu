package uhx.oauth;

import haxe.Utf8;
import uhx.crypto.Base16;
import uhx.crypto.Base64;
import haxe.unit.TestCase;
import uhx.oauth.spec1_0a.Common;
import uhx.oauth.spec1_0a.Client;
import uhx.oauth.spec1_0a.Request;
import uhx.oauth.spec1_0a.i.IRequest;

using StringTools;
using uhx.web.URI;
using uhx.oauth.spec1_0a.util.ClientTools;
using uhx.oauth.spec1_0a.util.SignatureTools;

/**
 * ...
 * @author Skial Bainn
 */
class OAuth10aSpec extends TestCase {
	
	public var request_url:String = 'http://term.ie/oauth/example/request_token.php';
	public var access_url:String = 'http://term.ie/oauth/example/access_token.php';
	public var auth_url:String = 'http://term.ie/oauth/example/echo_api.php';
	public var c:Client;
	public var r:IRequest;
	
	public function new() {
		super();
	}
	
	override public function setup() {
		c = new Client();
		c.consumer.key = 'key';
		c.consumer.secret = 'secret';
		
		c.access.request = new URI( request_url );
		
		var time_stamp = '0';
		var nonce = '0';
		
		r = new Request();
		r.url = c.access.request;
		r.add('oauth_consumer_key', c.consumer.key);
		r.add('oauth_nonce', nonce);
		r.add('oauth_signature_method', c.signature.toString());
		r.add('oauth_timestamp', '' + time_stamp);
		r.add('oauth_token', '');
		r.add('oauth_version', '1.0');
		
		c.http_request = r;
	}
	
	public function testRequestToken_Post() {
		var expected = 'POST&http%3A%2F%2Fterm.ie%2Foauth%2Fexample%2Frequest_token.php&oauth_consumer_key%3Dkey%26oauth_nonce%3D0%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D0%26oauth_token%3D%26oauth_version%3D1.0';
		assertEquals(expected, r.base);
	}
	
	// This tests the value __before__ SHA1, Base64 encodings
	public function testRequestSignature_plain() {
		var expected = c.consumer.secret + '&' + c.token.secret;
		assertEquals(expected, c.generateKey());
	}
	
	// This tests the value __after__ its been SHA1 encoded
	public function testRequestSignature_sha1() {
		// from an online sha1 tool - r.base SHA1 encoded with `secret&` as the key
		var expected = '526c0fe3e210ba1f94789912015002d61ced17a3';
		assertEquals(expected, c.generateSHA1());
	}
	
	public function testRequestSignature_digest() {
		// from http://hueniverse.com/oauth/guide/authentication/ _create your own
		// option. 
		var expected = 'UmwP4+IQuh+UeJkSAVAC1hztF6M=';
		assertEquals(expected, c.generateDigest());
	}
	
	public function testRequestAuth_BaseString() {
		c.token.key = 'accesskey';
		c.token.secret = 'accesssecret';
		
		r.add(Common.TOKEN, c.token.key);
		
		r.url.path = '/oauth/example/access_token.php';
		r.url.query.set('fname', ['skial']);
		r.url.query.set('lname', ['bainn']);
		var e = 'POST&http%3A%2F%2Fterm.ie%2Foauth%2Fexample%2Faccess_token.php&fname%3Dskial%26lname%3Dbainn%26oauth_consumer_key%3Dkey%26oauth_nonce%3D0%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D0%26oauth_token%3Daccesskey%26oauth_version%3D1.0';
		assertEquals(e, r.base);
	}
	
	public function testRequestAuthSecret_plain() {
		c.token.key = 'accesskey';
		c.token.secret = 'accesssecret';
		
		r.add(Common.TOKEN, c.token.key);
		
		r.url.path = '/oauth/example/access_token.php';
		r.url.query.set('fname', ['skial']);
		r.url.query.set('lname', ['bainn']);
		var e = 'secret&accesssecret';
		assertEquals(e, c.generateKey());
	}
	
	public function testRequestAuthSecret_hmac_sha1() {
		c.token.key = 'accesskey';
		c.token.secret = 'accesssecret';
		
		r.add(Common.TOKEN, c.token.key);
		
		r.url.path = '/oauth/example/access_token.php';
		r.url.query.set('fname', ['skial']);
		r.url.query.set('lname', ['bainn']);
		var e = 'K6hFN+ya/XsfZxMbP2FjktUGqEQ=';
		assertEquals(e, c.generateDigest());
	}
	
}