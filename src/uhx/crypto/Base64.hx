package uhx.crypto;

import haxe.crypto.BaseCode;
import haxe.io.Bytes;
import haxe.io.BytesData;

using Std;
using haxe.io.Bytes;

/**
 * ...
 * @author Skial Bainn
 */

class Base64 {
	
	public static var LINE_SEPARATOR:String = '\r\n';
	public static var MAX_LENGTH:Int = 76;
	public static var CHAR_63:String = '+';
	public static var CHAR_64:String = '/';
	public static var PAD:String = '=';
	public static var CHARS:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
	
	/**
	 * Accepts either `String` or `haxe.io.Bytes`. Any other value will return `null`.
	 * @return String
	 */
	public static function encode(s:Dynamic):String {
		var data:Bytes = if (s.is(String)) {
			Bytes.ofString(cast s);
		} else if (s.is(Bytes)) {
			cast s;
		} else {
			null;
		}
		
		if (data == null) throw 'Unsupported type passed. Only String and haxe.io.Bytes are supported.';
		
		var characters = CHARS + CHAR_63 + CHAR_64;
		var baseCode = new BaseCode( Bytes.ofString( characters ) );
		var output = baseCode.encodeBytes( data );
		
		var result = output.toString();
		var length = result.length;
		
		switch (result.length % 4) {
			case 2:
				result += PAD;
				result += PAD;
			case 3:
				result += PAD;
			case _:
		}
		
		// Insert LINE_SEPARATOR every MAX_LENGTH characters
		if ( (LINE_SEPARATOR != null && LINE_SEPARATOR != '') && result.length > MAX_LENGTH ) {
			var buffer = new StringBuf();
			length = 0;
			
			while (result.length > length) {
				buffer.add( (length != 0 ? LINE_SEPARATOR : '') + result.substr(length, MAX_LENGTH) );
				length += MAX_LENGTH;
			}
			
			result = buffer.toString();
		}
		
		return result;
	}
	
	/**
	 * Base64 transfer encoding for MIME (RFC 2045)
	 */
	@:extern public static inline function asRFC2045():Void {
		CHAR_63 = '+';
		CHAR_64 = '/';
		PAD = '=';
		LINE_SEPARATOR = '\r\n';
		MAX_LENGTH = 76;
	}
	
	/**
	 * Standard Base64 encoding for RFC 3548.
	 */
	@:extern public static inline function asRFC3548(?lineSeparators = '\r\n'):Void {
		CHAR_63 = '+';
		CHAR_64 = '/';
		PAD = '=';
		LINE_SEPARATOR = lineSeparators;
		MAX_LENGTH = (lineSeparators == '\r\n') ? 76 : 64;
	}
	
	/**
	 * Standard Base64 encoding for RFC 4648.
	 * Line Length is application dependent. 
	 * If Padding is true it will be `%3D`. 
	 * Padding is not recommended.
	 */
	@:extern public static inline function asRFC4648(lineLength:Int, ?padding:Bool = false):Void {
		CHAR_63 = '-';
		CHAR_64 = '_';
		PAD = (padding) ? '%3D' : '';
		LINE_SEPARATOR = '';
		MAX_LENGTH = lineLength;
	}
	
	/**
	 * Same as RFC 4648.
	 * -----
	 * Line Length is application dependent. 
	 * If Padding is true it will be `%3D`. 
	 * Padding is not recommended.
	 */
	@:extern public static inline function forURLEncoding(lineLength:Int, ?padding:Bool = false):Void {
		asRFC4648(lineLength, padding);
	}
	
	/**
	 * Modified Base64 for Regular Expressions (non standard).
	 * -----
	 * Line Length is application dependent;
	 */
	@:extern public static inline function forRegularExpressions(lineLength:Int):Void {
		CHAR_63 = '!';
		CHAR_64 = '-';
		PAD = '';
		LINE_SEPARATOR = '';
		MAX_LENGTH = lineLength;
	}
	
}