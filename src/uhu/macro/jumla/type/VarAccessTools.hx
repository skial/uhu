package uhu.macro.jumla.type;

import haxe.macro.Type;

using haxe.EnumTools;

/**
 * ...
 * @author Skial Bainn
 */
class VarAccessTools {

	public static function toString(access:VarAccess):String {
		var result = null;
		
		result = switch (access) {
			case AccNormal:
				'default';
			case AccNo:
				'null';
			case AccNever:
				'never';
			case AccCall:
				'call';
			case _:
				'never';
		}
		
		return result;
	}
	
	public static function is(access:VarAccess, what:EnumValue):Bool {
		return (access != null && access.getName() == what.getName());
	}
	
	public static inline function isInline(access:VarAccess):Bool {
		return is( access, AccInline );
	}
	
	public static function isNormal(access:VarAccess):Bool {
		var result = false;
		
		switch (access) {
			case AccNormal:
				result = true;
			case _:
				result = false;
		}
		
		return result;
	}
	
	public static function isDynamic(access:VarAccess):Bool {
		var result = false;
		
		switch (access) {
			case AccResolve:
				result = true;
			case _:
				result = false;
		}
		
		return result;
	}
	
}