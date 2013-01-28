package uhu.core;

import uhu.StdTypes;

/**
 * @author Skial Bainn
 */

#if uhu_native
	
	#if php
	typedef Hash<T> = uhu.php.PHPHash<T>;
	#end
	
#else
typedef Hash<T> = StdHash<T>;
#end