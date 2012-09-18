package uhu.php.native;

/**
 * ...
 * @author Skial Bainn
 */

extern class NativeMath {

	// http://php.net/manual/en/function.rand.php
	public static inline function rand(?min:Int, ?max:Int):Int {
		return untyped __call__('rand', min, max);
	}
	
}