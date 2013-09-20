package uhx.http.impl;

import haxe.io.Bytes;
import de.polygonal.core.fmt.ASCII;

using Lambda;
using StringTools;

/**
 * ...
 * @author Skial Bainn
 */
class Rules {

	public static inline function OCTET(value:String):Bool {
		return Bytes.ofString( value ).length <= 8;
	}
	
	public static inline function CHAR(x:Int):Bool {
		return ASCII.isASCII( x );
	}
	
	public static inline function UPALPHA(x:Int):Bool {
		return ASCII.isUpperCaseAlphabetic( x );
	}
	
	public static inline function LOALPHA(x:Int):Bool {
		return ASCII.isLowerCaseAlphabetic( x );
	}
	
	public static inline function ALPHA(x:Int):Bool {
		return ASCII.isAlphabetic( x );
	}
	
	public static inline function DIGIT(x:Int):Bool {
		return ASCII.isDigit( x );
	}
	
	public static inline function CTL(x:Int):Bool {
		return x >= 0 && x <= 31 || x == 127;
	}
	
	public static inline function CR(x:Int):Bool {
		return x == ASCII.CARRIAGERETURN;
	}
	
	public static inline function LF(x:Int):Bool {
		return x == ASCII.NEWLINE;
	}
	
	public static inline function SP(x:Int):Bool {
		return x == ASCII.SPACE;
	}
	
	public static inline function HT(x:Int):Bool {
		return x == ASCII.TAB;
	}
	
	public static inline function DOUBLE_QUOTE(x:Int):Bool {
		return x == ASCII.QUOTEDBL;
	}
	
	public static inline function CRLF(x:Int):Bool {
		return CR( x ) || LF( x );
	}
	
	public static inline function LWS(x:Int):Bool {
		return CRLF( x ); // TODO http://tools.ietf.org/html/rfc2616#section-2.2
	}
	
	public static function TEXT(value:String):Bool {
		var result = true;
		
		for (i in 0...value.length) {
			
			if ( !OCTET( value.charAt( i ) ) && CTL( value.charAt( i ).charCodeAt( 0 ) ) ) {
				result = false;
				break;
			}
			
		}
		
		return result;
	}
	
	public static var SEP:Array<String> = ['(', ')', '<', '>', '@', ',', ';', ':', '\\', '"', '/', "[", "]", "?", "=", "{", "}"];
	
	public static function seperators(value:String):Bool {
		var result = true;
		
		for (i in 0...value.length) {
			var v:String = value.charAt( i );
			
			if (SEP.indexOf( v ) == -1 || SP( v.charCodeAt( 0 ) ) || HT( v.charCodeAt( 0 ) )) {
				
				result = false;
				break;
				
			}
			
		}
		
		return result;
	}
	
	public static function tokens(value:String):Bool {
		var result = true;
		
		for (i in 0...value.length) {
			var v:String = value.charAt( i );
			
			if ( !CHAR( v.charCodeAt( 0 ) ) || (CTL( v.charCodeAt( 0 ) ) || seperators( v )) ) {
				result = false;
				break;
			}
			
		}
		
		return result;
	}
	
	public static function ctext(value:String):Bool {
		var result = true;
		
		for (i in 0...value.length) {
			var v:String = value.charAt( i );
			
			if (!TEXT( v ) && (v == '(' || v == ')')) {
				result = false;
				break;
			}
			
		}
		
		return result;
	}
	
	public static function quoted_pair(value:String):Bool {
		return value.startsWith('\\') && CHAR( value.charCodeAt( 0 ) );
	}
	
	public static function comment(value:String):Bool {
		var result = true;
		
		if (value.startsWith('(') && value.endsWith(')')) {
			var v = value.substr(1, value.length - 1);
			
			if (!ctext( v ) || !quoted_pair( v ) || !comment( v )) {
				result = false;
			}
			
		} else {
			result = false;
		}
		
		return result;
	}
	
	public static function qdtext(value:String):Bool {
		return TEXT( value ) && value.indexOf('"') == -1;
	}
	
	public static function quoted_string(value:String):Bool {
		var result = true;
		
		if (value.startsWith('"') && value.endsWith('"')) {
			var v = value.substr(1, value.length - 1);
			
			if (!qdtext( v ) || !quoted_pair( v )) {
				result = false;
			}
			
		} else {
			result = false;
		}
		
		return result;
	}
	
}