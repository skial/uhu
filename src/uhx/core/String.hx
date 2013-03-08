package uhu.core;

import uhu.StdTypes;

/**
 * @author Skial Bainn
 */

#if uhu_native
	
	#if php
	typedef String = uhu.php.PHPString;
	#else
	typedef String = StdString;
	#end
	
#else
typedef String = StdString;
#end