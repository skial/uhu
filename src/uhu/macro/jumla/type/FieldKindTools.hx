package uhu.macro.jumla.type;

import haxe.macro.Expr;
import haxe.macro.Type;

/**
 * ...
 * @author Skial Bainn
 */

class FieldKindTools {
	
	public static function is(kind:FieldKind, what:String):Bool {
		return (kind.getName() == what);
	}
	
	public static inline function isVar(kind:FieldKind):Bool {
		return is( kind, 'FVar' );
	}
	
	public static inline function isMethod(kind:FieldKind):Bool {
		return is( kind, 'FMethod' );
	}
	
	public static function getter(kind:FieldKind):VarAccess {
		var result = null;
		
		switch (kind) {
			case FVar(g, _):
				result = g;
				
			case _:
				
		}
		
		return result;
	}
	
	public static function setter(kind:FieldKind):VarAccess {
		var result = null;
		
		switch (kind) {
			case FVar(_, s):
				result = s;
				
			case _:
				
		}
		
		return result;
	}
	
	public static inline function access(kind:FieldKind): { getter:VarAccess, setter:VarAccess } {
		return { getter:getter( kind ), setter:setter( kind ) };
	}
	
}