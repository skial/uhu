package uhx.macro.jumla.expr;

import haxe.macro.Type;
import haxe.macro.Expr;
import uhx.macro.jumla.a.AField;
import uhx.macro.jumla.a.AFields;

using Lambda;
using uhx.macro.Jumla;
/**
 * ...
 * @author Skial Bainn
 */
class FieldTools {

	public static function sugar(t:Field):AField return t;
	
}

class ManyFieldTools {
	
	public static function meta(v:ManyFields, key:String):Array<AField> {
		return Lambda.filter(v.original, function(f) return f.meta.exists( key ) ).array();
	}
	
}