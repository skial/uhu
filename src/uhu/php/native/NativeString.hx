package uhu.php.native;

/**
 * ...
 * @author Skial Bainn
 */

 
// http://php.net/manual/en/ref.strings.php
extern class NativeString implements ArrayAccess<NativeString> {
	
	// http://www.php.net/manual/en/function.strlen.php
	public static inline function strlen(string:String):Int {
		return untyped __call__('strlen', string);
	}
	
	// http://www.php.net/manual/en/function.strtoupper.php
	public static inline function strtoupper(string:String):String {
		return untyped __call__('strtoupper', string);
	}
	
	// http://www.php.net/manual/en/function.strtolower.php
	public static inline function strtolower(string:String):String {
		return untyped __call__('strtolower', string);
	}
	
	public static inline function charAt(string:String, index:Int):String {
		return untyped string[index];
	}
	
	public static inline function charCodeAt(string:String, index:Int):Null<Int> {
		return untyped __call__('ord', string[index]);
	}
	
	// http://www.php.net/manual/en/function.ord.php
	public static inline function ord(string:String):Int {
		return untyped __call__('ord', string);
	}
	
	// alias of strpos
	public static inline function indexOf(string:String, str:String, ?startIndex:Int):Int {
		return untyped __call__('strpos', string, str, startIndex);
	}
	
	// http://www.php.net/manual/en/function.strpos.php
	public static inline function strpos(haystack:String, needle:String, ?offset:Int):Int {
		return untyped __call__('strpos', haystack, needle, offset);
	}
	
	// alias of strrpos
	public static inline function lastIndexOf(string:String, str:String, ?startIndex:Int):Int {
		return untyped __call__('strrpos', string, str, startIndex);
	}
	
	// http://www.php.net/manual/en/function.strrpos.php
	public static inline function strrpos(haystack:String, needle:String, ?offset:Int):Int {
		return untyped __call__('strrpos', haystack, needle, offset);
	}
	
	// alias of explode
	public static inline function split(string:String, delimiter:String):NativeArray<NativeString> {
		return untyped __call__('explode', delimiter, string);
	}
	
	// http://www.php.net/manual/en/function.explode.php
	public static inline function explode(string:String, delimiter:String, ?limit:Int):NativeArray<String> {
		return untyped __call__('explode', delimiter, string, limit);
	}
	
	public static inline function substr(string:String, start:Int, ?length:Int):String {
		return untyped __call__('substr', string, start, length);
	}
	
	public static inline function toString(string:String):String {
		return string;
	}
	
	// alias of chr
	public static inline function fromCharCode(code:Int):String {
		return untyped __call__('chr', code);
	}
	
	// http://www.php.net/manual/en/function.chr.php
	public static inline function chr(ascii:Int):String {
		return untyped __call__('chr', ascii);
	}
	
}