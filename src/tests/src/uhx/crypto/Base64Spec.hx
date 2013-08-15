package uhx.crypto;

import utest.Assert;
import haxe.unit.TestCase;
import haxe.io.Bytes;
import haxe.io.BytesData;
import jonas.Base64;
import uhx.crypto.Base64 in UBase64;

/**
 * ...
 * @author Skial Bainn
 */
class Base64Spec {

	public var value:String = 'Skial Bainn';
	public var expected:String = 'U2tpYWwgQmFpbm4=';

	public function new() {
		
	}
	
	public function testJonas() {
		Assert.equals(expected, Base64.encode64(value));
	}
	
	public function testUhu() {
		Assert.equals(expected, UBase64.encode(value));
	}
	
	/**
	 * Test different input types for uhx.crypto.Base64
	 */
	
	public function testUhuType_String() {
		Assert.equals(expected, UBase64.encode(value));
	}
	
	public function testUhuType_Bytes() {
		Assert.equals(expected, UBase64.encode( Bytes.ofString(value) ));
	}
	
	// This will return `null`
	public function testUhuType_Float() {
		try {
			UBase64.encode( 0.0 );	//	This should fail and trigger the last assert.
			Assert.isTrue(false);
		} catch (e:Dynamic) {
			Assert.isTrue(true);
		}
	}
	
	/**
	 * Following examples from wikipedia
	 * @link http://en.wikipedia.org/wiki/Base64
	 */
	
	public function testJonas_wiki_1() {
		var v = '';
		var e = '';
		Assert.equals(e, Base64.encode64(v));
	}
	
	public function testUhu_wiki_1() {
		var v = '';
		var e = '';
		Assert.equals(e, UBase64.encode(v));
	}
	
	public function testJonas_wiki_2() {
		var v = 'f';
		var e = 'Zg==';
		Assert.equals(e, Base64.encode64(v));
	}
	
	public function testUhu_wiki_2() {
		var v = 'f';
		var e = 'Zg==';
		Assert.equals(e, UBase64.encode(v));
	}
	
	public function testJonas_wiki_3() {
		var v = 'fo';
		var e = 'Zm8=';
		Assert.equals(e, Base64.encode64(v));
	}
	
	public function testUhu_wiki_3() {
		var v = 'fo';
		var e = 'Zm8=';
		Assert.equals(e, UBase64.encode(v));
	}
	
	public function testJonas_wiki_4() {
		var v = 'foo';
		var e = 'Zm9v';
		Assert.equals(e, Base64.encode64(v));
	}
	
	public function testUhu_wiki_4() {
		var v = 'foo';
		var e = 'Zm9v';
		Assert.equals(e, UBase64.encode(v));
	}
	
	public function testJonas_wiki_5() {
		var v = 'foob';
		var e = 'Zm9vYg==';
		Assert.equals(e, Base64.encode64(v));
	}
	
	public function testUhu_wiki_5() {
		var v = 'foob';
		var e = 'Zm9vYg==';
		Assert.equals(e, UBase64.encode(v));
	}
	
	public function testJonas_wiki_6() {
		var v = 'fooba';
		var e = 'Zm9vYmE=';
		Assert.equals(e, Base64.encode64(v));
	}
	
	public function testUhu_wiki_6() {
		var v = 'fooba';
		var e = 'Zm9vYmE=';
		Assert.equals(e, UBase64.encode(v));
	}
	
	public function testJonas_wiki_7() {
		var v = 'foobar';
		var e = 'Zm9vYmFy';
		Assert.equals(e, Base64.encode64(v));
	}
	
	public function testUhu_wiki_7() {
		var v = 'foobar';
		var e = 'Zm9vYmFy';
		Assert.equals(e, UBase64.encode(v));
	}
	
	public function testJonas_wiki_8() {
		var v = 'pleasure.';
		var e = 'cGxlYXN1cmUu';
		Assert.equals(e, Base64.encode64(v));
	}
	
	public function testUhu_wiki_8() {
		var v = 'pleasure.';
		var e = 'cGxlYXN1cmUu';
		Assert.equals(e, UBase64.encode(v));
	}
	
	public function testJonas_wiki_9() {
		var v = 'leasure.';
		var e = 'bGVhc3VyZS4=';
		Assert.equals(e, Base64.encode64(v));
	}
	
	public function testUhu_wiki_9() {
		var v = 'leasure.';
		var e = 'bGVhc3VyZS4=';
		Assert.equals(e, UBase64.encode(v));
	}
	
	public function testJonas_wiki_10() {
		var v = 'easure.';
		var e = 'ZWFzdXJlLg==';
		Assert.equals(e, Base64.encode64(v));
	}
	
	public function testUhu_wiki_10() {
		var v = 'easure.';
		var e = 'ZWFzdXJlLg==';
		Assert.equals(e, UBase64.encode(v));
	}
	
	public function testJonas_wiki_11() {
		var v = 'asure.';
		var e = 'YXN1cmUu';
		Assert.equals(e, Base64.encode64(v));
	}
	
	public function testUhu_wiki_11() {
		var v = 'asure.';
		var e = 'YXN1cmUu';
		Assert.equals(e, UBase64.encode(v));
	}
	
	public function testJonas_wiki_12() {
		var v = 'sure.';
		var e = 'c3VyZS4=';
		Assert.equals(e, Base64.encode64(v));
	}
	
	public function testUhu_wiki_12() {
		var v = 'sure.';
		var e = 'c3VyZS4=';
		Assert.equals(e, UBase64.encode(v));
	}
	
	/**
	 * Test base64 line length with large text
	 * @link http://en.wikipedia.org/wiki/Base64
	 */
	
	public function testJonas_wiki_long_1() {
		var v = 'Man is distinguished, not only by his reason, but by this singular passion from other animals, which is a lust of the mind, that by a perseverance of delight in the continued and indefatigable generation of knowledge, exceeds the short vehemence of any carnal pleasure.';
		var e = 'TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb24sIGJ1dCBieSB0aGlz
IHNpbmd1bGFyIHBhc3Npb24gZnJvbSBvdGhlciBhbmltYWxzLCB3aGljaCBpcyBhIGx1c3Qgb2Yg
dGhlIG1pbmQsIHRoYXQgYnkgYSBwZXJzZXZlcmFuY2Ugb2YgZGVsaWdodCBpbiB0aGUgY29udGlu
dWVkIGFuZCBpbmRlZmF0aWdhYmxlIGdlbmVyYXRpb24gb2Yga25vd2xlZGdlLCBleGNlZWRzIHRo
ZSBzaG9ydCB2ZWhlbWVuY2Ugb2YgYW55IGNhcm5hbCBwbGVhc3VyZS4=';
		Assert.equals(e, new Base64('+', '/', '=', 76).encode_string(v));
	}
	
	public function testUhu_wiki_long_1() {
		var v = 'Man is distinguished, not only by his reason, but by this singular passion from other animals, which is a lust of the mind, that by a perseverance of delight in the continued and indefatigable generation of knowledge, exceeds the short vehemence of any carnal pleasure.';
		var e = 'TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb24sIGJ1dCBieSB0aGlz
IHNpbmd1bGFyIHBhc3Npb24gZnJvbSBvdGhlciBhbmltYWxzLCB3aGljaCBpcyBhIGx1c3Qgb2Yg
dGhlIG1pbmQsIHRoYXQgYnkgYSBwZXJzZXZlcmFuY2Ugb2YgZGVsaWdodCBpbiB0aGUgY29udGlu
dWVkIGFuZCBpbmRlZmF0aWdhYmxlIGdlbmVyYXRpb24gb2Yga25vd2xlZGdlLCBleGNlZWRzIHRo
ZSBzaG9ydCB2ZWhlbWVuY2Ugb2YgYW55IGNhcm5hbCBwbGVhc3VyZS4=';
		Assert.equals(e, UBase64.encode(v));
	}
	
	/**
	 * Other sources
	 * @link https://github.com/couchbase/libcouchbase/blob/master/tests/base64-unit-test.cc
	 */
	
	public function testJonas_wiki_13() {
		var v = 'Administrator:password';
		var e = 'QWRtaW5pc3RyYXRvcjpwYXNzd29yZA==';
		Assert.equals(e, Base64.encode64(v));
	}
	
	public function testUhu_wiki_13() {
		var v = 'Administrator:password';
		var e = 'QWRtaW5pc3RyYXRvcjpwYXNzd29yZA==';
		Assert.equals(e, UBase64.encode(v));
	}
	
	public function testJonas_wiki_14() {
		var v = '@';
		var e = 'QA==';
		Assert.equals(e, Base64.encode64(v));
	}
	
	public function testUhu_wiki_14() {
		var v = '@';
		var e = 'QA==';
		Assert.equals(e, UBase64.encode(v));
	}
	
}