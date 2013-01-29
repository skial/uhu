package uhu.macro.jumla;

import haxe.macro.Type;

/**
 * @author Skial Bainn
 */

class TypeTools {
	
	// Compat code for tink_macros
	@:extern public static inline function getID(type:Type, ?reduce:Bool = false) {
		return getName(type);
	}
	
	public static function getName(type:Type):String {
		switch (type) {
			case TInst(t, _):
				return t.toString();
			case TEnum(t, _):
				return t.toString();
			case TType(t, _):
				return t.toString();
			#if haxe3
			case TAbstract(t, _):
				return t.toString();
			#end
			default:
				
		}
		
		return '';
	}
	
}