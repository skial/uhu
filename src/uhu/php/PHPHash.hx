package uhu.php;

/**
 * @author Skial Bainn
 */

abstract PHPHash(Hash<T>)<T> {

	/**
		Creates a new empty hashtable.
	**/
	public inline function new():Void {
		this = untyped __call__('array');
	}
	
	/**
		Set a value for the given key.
	**/
	public inline function set(key:String, value:T):Void untyped {
		this[key] = value;
	}

	/**
		Get a value for the given key.
	**/
	public function get(key:String):Null<T> untyped {
		return (null == this[key]) ? null : this[key];
	}

	/**
		Tells if a value exists for the given key.
		In particular, it's useful to tells if a key has
		a [null] value versus no value.
	**/
	public inline function exists(key:String):Bool untyped {
		return __call__('array_key_exists', key, this);
	}

	/**
		Removes a hashtable entry. Returns [true] if
		there was such entry.
	**/
	public inline function remove(key:String):Bool untyped {
		if (__call__('array_key_exists', key, this)) {
			__call__('unset', this[key]);
			return true;
		} else {
			return false;
		}
	}


	/**
		Returns an iterator of all keys in the hashtable.
	**/
	public inline function keys():Iterator<String> {
		return untyped __call__('array_keys', this);
	}

	/**
		Returns an iterator of all values in the hashtable.
	**/
	public inline function iterator():Iterator<T> {
		return untyped __call__('array_values', this);
	}

	/**
		Returns an displayable representation of the hashtable content.
	**/
	@:to public inline function toString() : String {
		var s = '{';
		var it = keys(this);
		for (i in it) {
			s += i;
			s += ' => ';
			s += '' + get(this, i);
			if (it.hasNext()) s += ', ';
		}
		return s += '}';
	}
	
}