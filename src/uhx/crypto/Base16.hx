package uhx.crypto;

import haxe.crypto.BaseCode;
import haxe.io.Bytes;

/**
 * ...
 * @author Skial Bainn
 */

 class Base16 {
	
	static var base = Bytes.ofString( '0123456789abcdef' );

	public static inline function encode16( s : String ) : String {
		return new BaseCode( base ).encodeString( s );
	}
	
	public static inline function encodeBytes16( b : Bytes ) : String {
		return new BaseCode( base ).encodeBytes( b ).toString();
	}
	
	public static inline function toHex( s : String ) : String {
		return encode16( s );
	}
	
	public static inline function decode16( s : String ) : String {
		return new BaseCode( base ).decodeString( s.toLowerCase() );
	}
	
	public static inline function decodeBytes16( s : String ) : Bytes {
		return new BaseCode( base ).decodeBytes( Bytes.ofString( s.toLowerCase() ) );
	}
	
	public static inline function fromHex( s : String ) : String {
		return decode16( s );
	}
	
}