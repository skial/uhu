package uhu.macro.jumla;

import uhu.macro.jumla.typedefs.TComplexString;

/**
 * ...
 * @author Skial Bainn
 */

class ComplexString {

	public static function toString(c:TComplexString):String {
		var result = '';
		
		result += c.name;
		
		for (p in c.params) {
			result += '<';
			result += toString(p);
			result += '>';
		}
		
		return result;
	}
	
}