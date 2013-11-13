package uhx.macro.jumla.type;

import haxe.macro.Type;
import uhx.macro.jumla.a.AClassType;

using Lambda;
using uhx.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class ClassTools {

	public static function sugar(t:ClassType):AClassType return t;
	
}

class ManyClassTools {
	public static function meta(v:ManyClassTypes, key:String):Array<AClassType> {
		return Lambda.filter(v, function(c) return c.meta.exists( key ) ).array();
	}
}