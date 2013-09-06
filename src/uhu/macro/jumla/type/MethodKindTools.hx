package uhu.macro.jumla.type;

import haxe.macro.Type;

/**
 * ...
 * @author Skial Bainn
 */

class MethodKindTools {
	
	public static function is(kind:MethodKind, what:EnumValue):Bool {
		var result = false;
		
		if (kind.getName() == what.getName()) result = true;
		
		return result;
	}
	
	public static function isNormal(kind:MethodKind):Bool { 
		var result = false;
		
		switch (kind) {
			case MethNormal:
				result = true;
			case _:
		}
		
		return result;
	}

	public static function isInline(kind:MethodKind):Bool { 
		var result = false;
		
		switch (kind) {
			case MethInline:
				result = true;
			case _:
		}
		
		return result;
	}
	
	public static function isDynamic(kind:MethodKind):Bool {
		var result = false;
		
		switch (kind) {
			case MethDynamic:
				result = true;
			case _:
		}
		
		return result;
	}
	
	public static function isMacro(kind:MethodKind):Bool {
		var result = false;
		
		switch (kind) {
			case MethMacro:
				result = true;
			case _:
		}
		
		return result;
	}
	
}