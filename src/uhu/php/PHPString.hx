package uhu.php;

/**
 * @author Skial Bainn
 */

abstract PHPString(String) {
	
	#if !display
	@:from public static inline function fromString(string:String):PHPString {
		return new PHPString(string);
	}
	#end

	/**
		The number of characters in [this] String.
	**/
	//public inline var length(default,null) : Int;
	public inline function length():Int untyped {
		return __call__('strlen', this);
	}

	/**
		Creates a copy from a given String.
	**/
	public inline function new(?string:String = '') {
		this = string;
	}

	/**
		Returns a String where all characters of [this] String are upper case.
		
		Affects the characters [a-z]. Other characters remain unchanged.
	**/
	public inline function toUpperCase():PHPString untyped {
		return __call__('strtoupper', this);
	}

	/**
		Returns a String where all characters of [this] String are lower case.
		
		Affects the characters [A-Z]. Other characters remain unchanged.
	**/
	public inline function toLowerCase():PHPString untyped {
		return __call__('strtolower', this);
	}

	/**
		Returns the character at position [index] of [this] String.
		
		If [index] is negative or exceeds [this].length, the empty String ""
		is returned.
	**/
	public inline function charAt(index:Int):PHPString untyped {
		return this[index];
	}

	/**
		Returns the character code at position [index] of [this] String.
		
		If [index] is negative or exceeds [this].length, null is returned.
		
		To obtain the character code of a single character, "x".code can be used
		instead to inline the character code at compile time. Note that this
		only works on String literals of length 1.
	**/
	public inline function charCodeAt(index:Int):Null<Int> untyped {
		return __call__('ord', this[index]);
	}

	/**
		Returns the position of the leftmost occurence of [str] within [this]
		String.
		
		If [startIndex] is given, the search is performed within the substring
		of [this] String starting from [startIndex]. Otherwise the search is
		performed within [this] String. In either case, the returned position
		is relative to the beginning of [this] String.
		
		If [str] cannot be found, -1 is returned.
	**/
	public inline function indexOf(str:PHPString, ?startIndex:Int):Int untyped {
		return __call__('strpos', this, str, startIndex);
	}

	/**
		Returns the position of the rightmost occurence of [str] within [this]
		String.
		
		If [startIndex] is given, the search is performed within the substring
		of [this] String from 0 to [startIndex]. Otherwise the search is
		performed within [this] String. In either case, the returned position
		is relative to the beginning of [this] String.
		
		If [str] cannot be found, -1 is returned.
	**/
	public inline function lastIndexOf(str:PHPString, ?startIndex:Int):Int untyped {
		return __call__('strrpos', this, str, startIndex);
	}

	/**
		Splits [this] String at each occurence of [delimiter].
		
		If [delimiter] is the empty String "", [this] String is split into an
		Array of [this].length elements, where the elements correspond to the
		characters of [this] String.
		
		If [delimiter] is not found within [this] String, the result is an Array
		with one element, which equals [this] String.
		
		If [delimiter] is null, the result is unspecified.
		
		Otherwise, [this] String is split into parts at each occurence of
		[delimiter]. If [this] String starts (or ends) with [delimiter}, the
		result Array contains a leading (or trailing) empty String "" element.
		Two subsequent delimiters also result in an empty String "" element.
	**/
	public inline function split(delimiter:PHPString):Array<PHPString> untyped {
		return __call__('explode', delimiter, this);
	}

	/**
		Returns [len] characters of [this] String, starting at position [pos].
		
		If [len] is omitted, all characters from position [pos] to the end of
		[this] String are included.
		
		If [pos] is negative, its values is calculated from the end	of [this]
		String by [this].length + [pos]. If this yields a negative value, 0 is
		used instead.
		
		If [len] is negative, the result is unspecified.
	**/
	public inline function substr(pos:Int, ?len:Int):PHPString untyped {
		return __call__('substr', this, pos, len);
	}

	/**
		Returns the part of [this] String from [startIndex] to [endIndex].
		
		If [endIndex] is omitted, [this].length is used instead.
		
		If [startIndex] or [endIndex] are negative, 0 is used instead.
		
		If [startIndex] exceeds [endIndex], they are swapped.
	**/
	public inline function substring(startIndex:Int, ?endIndex:Int):PHPString untyped {
		return __call__('substr', this, startIndex, endIndex);
	}

	/**
		Returns the String itself.
	**/
	@:to public inline function toString():String {
		return cast this;
	}

	/**
		Returns the String corresponding to the character code [code].
		
		If [code] is negative or has another invalid value, the result is
		unspecified.
	**/	
	public static inline function fromCharCode(code:Int):PHPString untyped {
		return __call__('chr', code);
	}
	
}