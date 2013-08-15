package uhx.web;

import utest.Assert;
import uhx.web.URI;

using uhx.web.URL;

/**
 * ...
 * @author Skial Bainn
 */
class URISpec {

	public function new() {
		
	}
	
	public var v:URI;
	public var e:String;
	
	/**
	 * Tests based on jsuri
	 * @link http://code.google.com/p/jsuri/
	 */
	
	public function testURL_empty() {
		e = '';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_slash() {
		e = '/';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_trailing_slash() {
		e = 'tutorial1/';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_rel_path() {
		e = '/experts/';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_rel_file_leading_slash() {
		e = '/index.html';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_rel_dir_file() {
		e = 'tutorial2/index.html';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_rel_parent_dir() {
		e = '../';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_rel_grandparents_dir() {
		e = '../../../';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_rel_current_dir() {
		e = './';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_rel_current_dir_doc() {
		e = './index.html';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_3_level_domain() {
		e = 'www.example.com';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_absolute_url() {
		e = 'http://www.example.com/index.html';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_absolute_url_secure() {
		e = 'https://www.example.com/index.html';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_absolute_url_port() {
		e = 'http://www.example.com:8080/index.html';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_absolute_url_secure_port() {
		e = 'https://www.example.com:4433/index.html';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_rel_path_hash() {
		e = '/index.html#about';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_absolute_path_hash() {
		e = 'http://www.example.com/index.html#about';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_rel_path_query() {
		e = '/index.html?a=1&b=2';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_absolute_path_query() {
		e = 'http://www.test.com/index.html?a=1&b=2';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_absolute_path_query_hash() {
		e = 'http://www.test.com/index.html?a=1&b=2#a';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_multi_synonymous_query() {
		e = 'http://www.test.com/index.html?arr=1&arr=2&arr=3&arr=3&b=2';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_blank_query() {
		e = 'http://www.test.com/index.html?arr=1&arr=2';
		v = 'http://www.test.com/index.html?arr=1&arr=&arr=2'.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_missing_scheme() {
		e = '//www.test.com/';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_path_query() {
		e = '/contacts?name=m';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_scheme_auth_host_port() {
		e = 'http://me:here@test.com:81/this/is/a/path';
		v = e.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_replace_scheme() {
		e = 'https://test.com';
		v = 'http://test.com'.toURL();
		v.scheme = 'https';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_replace_scheme_colon() {
		e = 'https://test.com';
		v = 'http://test.com'.toURL();
		v.scheme = 'https:';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_scheme_removed() {
		e = '//test.com';
		v = 'http://test.com'.toURL();
		v.scheme = '';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_username_password() {
		e = 'http://username:pass@test.com';
		v = 'http://test.com'.toURL();
		v.username = 'username';
		v.password = 'pass';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_hostname_rel_path() {
		e = 'wherever.com/index.html';
		v = '/index.html'.toURL();
		v.hostname = 'wherever.com';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_change_hostname() {
		e = 'http://wherever.com';
		v = 'http://test.com'.toURL();
		v.hostname = 'wherever.com';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_try_add_port() {
		e = '/index.html';
		v = '/index.html'.toURL();
		v.port = '8080';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_port() {
		e = 'http://test.com:8080';
		v = 'http://test.com'.toURL();
		v.port = '8080';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_path() {
		e = 'test.com/some/article.html';
		v = 'test.com'.toURL();
		v.path = '/some/article.html';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_delete_path() {
		e = 'http://test.com';
		v = 'http://test.com/index.html'.toURL();
		v.path = '';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_query_to_nothing() {
		e = '?this=that&something=else';
		v = ''.toURL();
		v.query.set('this', ['that']);
		v.query.set('something', ['else']);
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_query_to_rel_path() {
		e = '/some/file.html?this=that&something=else';
		v = '/some/file.html'.toURL();
		v.query.set('this', ['that']);
		v.query.set('something', ['else']);
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_query_to_domain() {
		e = 'test.com/?this=that&something=else';
		v = 'test.com'.toURL();
		v.query.set('this', ['that']);
		v.query.set('something', ['else']);
		Assert.equals(e, v.toString());
	}
	
	public function testURL_swap_query() {
		e = 'www.test.com/?this=that&something=else';
		v = 'www.test.com?this=that&a=1&b=2;c=3'.toURL();
		v.query.remove('a');
		v.query.remove('b');
		v.query.set('something', ['else']);
		Assert.equals(e, v.toString());
	}
	
	public function testURL_delete_query() {
		e = 'www.test.com';
		v = 'www.test.com?this=that&a=1&b=2;c=3'.toURL();
		v.query.remove('a');
		v.query.remove('b');
		v.query.remove('this');
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_fragment() {
		e = 'test.com/#content';
		v = 'test.com'.toURL();
		v.fragment = 'content';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_fragment_with_prefix() {
		e = 'test.com/#content';
		v = 'test.com'.toURL();
		v.fragment = '#content';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_fragment_to_path() {
		e = 'a/b/c/123.html#content';
		v = 'a/b/c/123.html'.toURL();
		v.fragment = 'content';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_change_fragment() {
		e = 'a/b/c/123.html#about';
		v = 'a/b/c/123.html#content'.toURL();
		v.fragment = 'about';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_delete_fragment() {
		e = 'a/b/c/123.html';
		v = 'a/b/c/123.html#content'.toURL();
		v.fragment = '';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_query_missing_value() {
		e = 'test.com/';
		v = 'test.com/?11='.toURL();
		Assert.equals(e, v.toString());
	}
	
	public function testURL_query_no_equal_in_original() {
		e = 'test.com/';
		v = 'test.com/?11'.toURL();
		Assert.equals(e, v.toString());
	}
	
}