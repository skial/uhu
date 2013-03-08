package uhx.util;

/**
 * @author Skial Bainn
 */

#if php
typedef URLParser = uhx.util.impl.URLParser_php;
#else
typedef URLParser = uhx.util.impl.URLParser;
#end