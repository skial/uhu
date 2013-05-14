package uhu.macro.jumla;

import haxe.macro.Type;
import haxe.macro.Expr;

/**
 * @author Skial Bainn
 */

class TypeTools {
	
	// Compat code for tink_macros
	@:extern public static inline function getID(type:Type, ?reduce:Bool = false) {
		return getName(type);
	}
	
	public static inline function toString(t:Type):String {
		return getName( t );
	}
	
	public static inline function isEnum(type:Type):Bool {
		return type.getName() == 'TEnum';
	}
	
	public static inline function isClass(type:Type):Bool {
		return type.getName() == 'TInst';
	}
	
	public static inline function isTypedef(type:Type):Bool {
		return type.getName() == 'TType';
	}
	
	public static inline function isFunction(type:Type):Bool {
		return type.getName() == 'TFun';
	}
	
	public static inline function isStructure(type:Type):Bool {
		return (type.getName() == 'TAnonymous' || isTypedef( type ));
	}
	
	public static inline function isAbstract(type:Type):Bool {
		return type.getName() == 'TAbstract';
	}
	
	public static inline function isDynamic(type:Type):Bool {
		return type.getName() == 'TDynamic';
	}
	
	public static function getName(type:Type):String {
		switch (type) {
			case TInst(t, _):
				return t.toString();
			case TEnum(t, _):
				return t.toString();
			case TType(t, _):
				return t.toString();
			case TAbstract(t, _):
				return t.toString();
			default:
				
		}
		
		return '';
	}
	
}