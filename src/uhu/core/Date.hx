package uhu.core;

import uhu.StdTypes;

/**
 * @author Skial Bainn
 */

#if uhu_native
	
	#if php
	typedef Date = uhu.php.PHPDate;
	#else
	typedef Date = StdDate;
	#end
	
#else
typedef Date = StdDate;
#end