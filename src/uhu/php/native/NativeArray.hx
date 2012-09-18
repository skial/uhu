package uhu.php.native;

/**
 * ...
 * @author Skial Bainn
 */

extern class SortFlags {
	public static inline var SORT_REGULAR:Int = untyped __php__('SORT_REGULAR');
	public static inline var SORT_NUMERIC:Int = untyped __php__('SORT_REGULAR');
	public static inline var SORT_STRING:Int = untyped __php__('SORT_STRING');
	public static inline var SORT_LOCALE_STRING:Int = untyped __php__('SORT_LOCALE_STRING');
}

extern class NativeArray<T> implements ArrayAccess<T> {
	
	// allow access to associative array - act as Hash.hx
	public inline function get(key:String):T {
		return untyped this[key];
	}
	
	// allow access to associative array - act as Hash.hx
	public inline function set(key:String, value:T):Void {
		untyped this[key] = value;
	}
	
	// alias for array_key_exists
	public inline function exists(key:String):Bool {
		return untyped __call__('array_key_exists', key, this);
	}
	
	// match Hash.hx
	public inline function remove(key:String):Void {
		untyped __call__('unset', this[key]);
	}
	
	// http://www.php.net/manual/en/function.next.php
	public inline function next():T {
		return untyped __call__('next', this);
	}
	
	// http://www.php.net/manual/en/function.array-values.php
	public inline function array_values():NativeArray<T> {
		return untyped __call__('array_values', this);
	}
	
	// http://www.php.net/manual/en/function.array-keys.php
	public inline function array_keys(?search_value:T, ?strict:Bool = false):NativeArray<T> {
		return untyped __call__('array_keys', this, search_value, strict);
	}
	
	// http://www.php.net/manual/en/function.array-key-exists.php
	public inline function array_key_exists(key:Dynamic):Bool {
		return untyped __call__('array_key_exists', key, this);
	}
	
	public static inline function create<T>():NativeArray<T> {
		return untyped __call__('array');
	}
	
	// http://www.php.net/manual/en/function.array-merge.php
	public inline function array_merge(array1:NativeArray<T>, array2:NativeArray<T>, ?array3:NativeArray<T>, ?array4:NativeArray<T>, ?array5:NativeArray<T>):NativeArray<T> {
		return untyped __call__('array_merge', this, array1, array2, array3, array4, array5);
	}
	
	// http://www.php.net/manual/en/function.implode.php
	public inline function implode(glue:String):String {
		return untyped __call__('implode', glue, this);
	}
	
	// http://www.php.net/manual/en/function.array-pop.php
	public inline function array_pop():Null<T> {
		return untyped __call__('array_pop', this);
	}
	
	// http://www.php.net/manual/en/function.array-push.php
	public inline function array_push(x:T):Int {
		return untyped __call__('array_push', this, x);
	}
	
	// http://www.php.net/manual/en/function.array-reverse.php
	public inline function array_reverse(?preserve_keys:Bool = false):NativeArray<T> {
		return untyped __call__('array_reverse', this, preserve_keys);
	}
	
	// http://www.php.net/manual/en/function.array-shift.php
	public inline function array_shift():Null<T> {
		return untyped __call__('array_shift', this);
	}
	
	// http://www.php.net/manual/en/function.array-slice.php
	public inline function array_slice(offset:Int, ?length:Int, ?preserve_keys:Bool = false):NativeArray<T> {
		return untyped __call__('array_slice', this, offset, length, preserve_keys);
	}
	
	// http://www.php.net/manual/en/function.sort.php
	public inline function sort<T>(?flags:Int):Bool {
		return untyped __call__('sort', this, flags);
	}
	
	// http://www.php.net/manual/en/function.array-splice.php
	public inline function array_splice(offset:Int, length:Int, ?replacement:NativeArray<T>):NativeArray<T> {
		return untyped __call__('array_splice', this, offset, length, replacement);
	}
	
	// http://www.php.net/manual/en/function.array-unshift.php
	public inline function array_unshift(x:T):Int {
		return untyped __call__('array_unshift', this, x);
	}
	
	// http://www.php.net/manual/en/function.array-search.php
	public inline function array_search(needle:T, ?strict:Bool = false):Dynamic {
		return untyped __call__('array_search', needle, this, strict);
	}
	
	// http://www.php.net/manual/en/function.key.php
	@:overload(function():String{})
	public inline function key():Int {
		return untyped __call__('key', this);
	}
	
	// http://www.php.net/manual/en/function.count.php
	public inline function count():Int {
		return untyped __call__('count', this);
	}
	
}