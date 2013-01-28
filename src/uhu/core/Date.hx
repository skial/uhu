package uhu.core;

import uhu.StdTypes;

/**
 * @author Skial Bainn
 */

#if uhu_native
	
	#if php
	typedef Date = uhu.php.PHPDate;
	#end
	
#else
typedef Date = StdDate;
#end