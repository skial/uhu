package uhu.macro.jumla;

import uhu.macro.jumla.t.TComplexString;

/**
 * ...
 * @author Skial Bainn
 */

class ComplexString {

	public static function toString(c:TComplexString):String {
		var result = '';
		
		result += c.name;
		
		if (c.params.length != 0) {

			result += '<';
			for (p in c.params) {
				if (c.params[0] != p) {
					result += ',';
				}
				result += toString(p);
			}
			result += '>';
			
		}

		/*for (p in c.params) {
			result += '<';
			result += toString(p);
			result += '>';
		}*/
		
		return result;
	}
	
}