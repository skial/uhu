package uhu.php;

import php.Lib;
import php.NativeArray;

/**
 * @author Skial Bainn
 */
 
@:arrayAccess
abstract PHPArray(Array<T>)<T> {
	
	#if !display
	/*@:from public static inline function fromNativeArray(array:NativeArray):PHPArray<T> {
		return untyped array;
	}*/
	
	/*@:from public static inline function fromArray<T>(array:Array<T>):PHPArray<T> {
		return untyped Lib.toPhpArray(array);
	}*/
	
	/*@:to public inline function toArray() {
		return untyped this;
	}*/
	#end
	
	/**
		The length of [this] Array.
	**/
	//public var length(get_length, null):Int;
	//public inline function get_length():Int {
	public inline function length():Int {
		return untyped __call__('count', this);
	}

	/**
		Creates a new Array.
	**/
	public inline function new():Void {
		this = untyped __call__('array');
	}

	/**
		Returns a new Array by appending the elements of [a] to the elements of
		[this] Array.
		
		This operation does not modify [this] Array.
		
		If [a] is the empty Array [], a copy of [this] Array is returned.
		
		The length of the returned Array is equal to the sum of [this].length
		and [a].length.
		
		If [a] is null, the result is unspecified.
	**/
	public inline function concat(a:PHPArray<T>):PHPArray<T> {
		return untyped __call__('array_merge', this, a);
	}

	/**
		Returns a string representation of [this] Array, with [sep] separating
		each element.
		
		The result of this operation is equal to Std.string(this[0]) + sep +
		Std.string(this[1]) + sep + ... + sep + Std.string(this[this.length-1]).
		
		If [this] is the empty Array [], the result is the empty String "". If
		[this] has exactly one element, the result is equal to a call to
		Std.string(this[0]).
		
		If [a] is null, the result is unspecified.
	**/
	public inline function join(sep:String):String {
		return untyped __call__('implode', sep, this);
	}

	/**
		Removes the last element of [this] Array and returns it.
		
		This operation modifies [this] Array in place.
		
		If [this] has at least one element, [this].length will decrease by 1.
		
		If [this] is the empty Array [], null is returned and the length remains
		0.
	**/
	public inline function pop():Null<T> {
		return untyped __call__('array_pop', this);
	}

	/**
		Adds the element [x] at the end of [this] Array and returns the offset
		it was added at.
		
		This operation modifies [this] Array in place.
		
		[this].length will increase by 1.
	**/
	public inline function push(x:T):Int {
		return untyped __call__('array_push', this, x);
	}

	/**
		Reverse the order of elements of [this] Array.
		
		This operation modifies [this] Array in place.
		
		If [this].length < 2, [this] remains unchanged.
	**/
	public inline function reverse():Void {
		return untyped __call__('array_reverse', this);
	}

	/**
		Removes the first element of [this] Array and returns it.
		
		This operation modifies [this] Array in place.
		
		If [this] has at least one element, [this].length and the index of each
		remaining element is decreased by 1.
		
		If [this] is the empty Array [], null is returned and the length remains
		0.
	**/
	public inline function shift():Null<T> {
		return untyped __call__('array_shift', this);
	}

	/**
		Creates a shallow copy of the range of [this] Array, starting at and
		including [pos], up to but not including [end].
		
		This operation does not modify [this] Array.
		
		The elements are not copied and retain their identity.
		
		If [end] is omitted or exceeds [this].length, it defaults to the end of
		[this] Array.
		
		If [pos] or [end] are negative, their offsets are calculated from the
		end	of [this] Array by [this].length + [pos] and [this].length + [end]
		respectively. If this yields a negative value, 0 is used instead.
		
		If [pos] exceeds [this].length or if [end} exceeds or equals [pos],
		the result is [].
	**/
	public inline function slice(pos:Int, ?end:Int):PHPArray<T> {
		return untyped __call__('array_slice', this, pos, end);
	}

	/**
		Sorts [this] Array according to the comparison function [f], where
		[f(x,y)] returns 0 if x == y, a positive Int if x > y and a
		negative Int if x < y.
		
		This operation modifies [this] Array in place.
		
		The sort operation is robust: Equal elements will retain their order.
		
		If [f] is null, the result is unspecified.
	**/
	public inline function sort(f:T->T->Int):Void {
		untyped __call__('uasort', this, f);
	}

	/**
		Removes [len] elements from [this] Array, starting at and including
		[pos], an returns them.
		
		This operation modifies [this] Array in place.
		
		If [len] is < 0 or [pos] exceeds [this].length, the result is the empty
		Array [].
		
		If [pos] is negative, its value is calculated from the end	of [this]
		Array by [this].length + [pos]. If this yields a negative value, 0 is
		used instead.
		
		If the sum of the resulting values for [len] and [pos] exceed
		[this].length, this operation will affect the elements from [pos] to the
		end of [this] Array.
		
		The length of the returned Array is equal to the new length of [this]
		Array subtracted from the original length of [this] Array. In other
		words, each element of the original [this] Array either remains in
		[this] Array or becomes an element of the returned Array.
	**/
	public inline function splice(pos:Int, len:Int):PHPArray<T> {
		return untyped __call__('array_splice', this, pos, len);
	}

	/**
		Returns a string representation of [this] Array.
		
		The result will include the individual elements' String representations
		separated by comma. The enclosing [ ] may be missing on some platforms,
		use Std.string() to get a String representation that is consistent
		across platforms.
	**/
	public inline function toString():String untyped {
		return '[' + __call__('implode', ',', this) + ']';
	}

	/**
		Adds the element [x] at the start of [this] Array.
		
		This operation modifies [this] Array in place.
		
		[this].length and the index of each Array element increases by 1.
	**/
	public inline function unshift(x:T):Void {
		return untyped __call__('array_unshift', this, x);
	}

	/**
		Inserts the element [x] at the position [pos].
		
		This operation modifies [this] Array in place.
		
		The offset is calculated like so:
			
		- If [pos] exceeds [this].length, the offset is [this].length.
		- If [pos] is negative, the offset is calculated from the end of [this]
		Array, i.e. [this].length + [pos]. If this yields a negative value,
		the offset is 0.
		- Otherwise, the offset is [pos].
		
		If the resulting offset does not exceed [this].length, all elements from
		and including that offset to the end of [this] Array are moved one index
		ahead.
	**/
	public inline function insert(pos:Int, x:T):Void {
		untyped __call__('array_splice', this, pos, x);
	}

	/**
		Removes the first occurence of [x] in [this] Array.
		
		This operation modifies [this] Array in place.
		
		If [x] is found by checking standard equality, it is removed from [this]
		Array and all following elements are reindexed acoordingly. The function
		then returns true.
		
		If [x] is not found, [this] Array is not changed and the function
		returns false.
	**/
	public inline function remove(x:T):Bool untyped {
		var bool = false;
		var len = __call__('count', this);
		
		for (i in 0...len) {
			if (this[i] == x) {
				// array_splice handles int based arrays, dont need to use array_values
				this = __call__('array_splice', this, i, 1);
				bool = true;
				break;
			}
		}
		
		return bool;
	}

	/**
		Returns a shallow copy of [this] Array.
		
		The elements are not copied and retain their identity, so
		a[i] == a.copy()[i] is true for any valid i. However, a == a.copy() is
		always false.
	**/
	public inline function copy():PHPArray<T> untyped {
		return this;
	}

	/**
		Returns an iterator of the Array values.
	**/
	public inline function iterator():Iterator<T> untyped {
		return this;
	}
	
	/*public inline function hasNext():Bool {
		if (this.length
	}
	
	public inline function next():T {
		return untyped __call__('next', this);
	}*/

	public inline function map<S>(f:T->S):PHPArray<S> untyped {
		return this;
	}
	
	public inline function filter(f:T->Bool):PHPArray<T> untyped {
		return this;
	}
	
}