package uhu.core;

import uhu.StdTypes;

/**
 * @author Skial Bainn
 */

#if uhu_native
	
	#if php
	typedef Array<T> = uhu.php.PHPArray<T>;
	#end
	
#else
typedef Array<T> = StdArray<T>;
#end