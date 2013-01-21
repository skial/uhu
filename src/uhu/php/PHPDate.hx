package uhu.php;

/**
 * @author Skial Bainn
 */

abstract PHPDate(Date) {
	
	#if !display
	@:from public static inline function fromDate(date:Date):PHPDate {
		return PHPDate.fromTime( date.getTime() );
	}
	
	@:from public static inline function fromInt(timestamp:Int):PHPDate {
		return PHPDate.fromTime( timestamp * 1000 );
	}
	#end
	
	/*@:to public inline function toDate():Date {
		return Date.fromTime( this );
	}*/

	/**
		Creates a new date object.
	**/
	public inline function new(year:Int, month:Int, day:Int, hour:Int, min:Int, sec:Int) {
		this = untyped __call__('mktime', hour, min, sec, month+1, day, year);
	}
	
	/**
		Returns the timestamp of the date. It's the number of milliseconds
		elapsed since 1st January 1970. It might only have a per-second precision
		depending on the platforms.
	**/
	public inline function getTime():Float {
		return untyped this * 1000;
	}

	/**
		Returns the hours value of the date (0-23 range).
	**/
	public inline function getHours():Int {
		return untyped __call__('intval', __call__('date', 'G', this));
	}

	/**
		Returns the minutes value of the date (0-59 range).
	**/
	public inline function getMinutes():Int {
		return untyped __call__('intval', __call__('date', 'i', this));
	}

	/**
		Returns the seconds of the date (0-59 range).
	**/
	public inline function getSeconds():Int {
		return untyped __call__('intval', __call__('date', 's', this));
	}

	/**
		Returns the full year of the date.
	**/
	public inline function getFullYear():Int {
		return untyped __call__('intval', __call__('date', 'Y', this));
	}

	/**
		Returns the month of the date (0-11 range).
	**/
	public inline function getMonth():Int {
		return untyped __call__('intval', __call__('date', 'n', this)) - 1;
	}

	/**
		Returns the day of the date (1-31 range).
	**/
	public inline function getDate():Int {
		return untyped __call__('intval', __call__('date', 'j', this));
	}

	/**
		Returns the week day of the date (0-6 range).
	**/
	public inline function getDay():Int {
		return untyped __call__('intval', __call__('date', 'w', this));
	}

	/**
		Returns a string representation for the Date, by using the
		standard format [YYYY-MM-DD HH:MM:SS]. See [DateTools.format] for
		other formating rules.
	**/
	public inline function toString():String {
		return untyped __call__('date', 'Y-m-d H:i:s', this);
	}

	/**
		Returns a Date representing the current local time.
	**/
	public static inline function now():Date {
		return untyped __call__('round', __call__('microtime', true), 3);
	}

	/**
		Returns a Date from a timestamp [t] which is the number of
		milliseconds elapsed since 1st January 1970.
	**/
	public static inline function fromTime(t:Float):Date {
		return untyped (t / 1000);
	}

	/**
		Returns a Date from a formated string of one of the following formats :
		[YYYY-MM-DD hh:mm:ss] or [YYYY-MM-DD] or [hh:mm:ss]. The first two formats
		are expressed in local time, the third in UTC Epoch.
	**/
	public static inline function fromString(s:String):Date {
		return untyped __call__('strtotime', s);
	}
	
}