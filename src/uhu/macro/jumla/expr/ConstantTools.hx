package uhu.macro.jumla.expr;

import haxe.macro.Expr;

using StringTools;
using haxe.EnumTools;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */

class ConstantTools {
	
	public static function clean(c:Constant):Constant {
		var result = c;
		
		switch (c) {
			case CIdent(s):
				result = CIdent( s.replace('`', '') );
			case _:
				
		}
		
		return result;
	}
	
	public static function getConst(e:Expr):Constant {
		var result = null;
		
		switch (e.expr) {
			case EConst(c):
				result = c;
			case _:
				
		}
		
		return result;
	}
	
	@:extern public static inline function toString(c:Constant):String {
		return c.printConstant();
	}
	
	public static function get(c:Constant) {
		var result:Dynamic = null;
		
		switch (c) {
			case CInt(v):
				result = Std.parseInt( v );
				
			case CFloat(v):
				result = Std.parseFloat( v );
				
			case CString(v):
				result = v;
				
			case CIdent(v):
				result = v;
				
			case CRegexp(r, o):
				result = new EReg( r, o );
				
		}
		
		return result;
	}
	
	@:extern public static inline function value(c:Constant) {
		return get( c );
	}
	
	public static function isInt(c:Constant):Bool {
		return (c.getName() == 'CInt');
	}
	
	public static function isFloat(c:Constant):Bool {
		return (c.getName() == 'CFloat');
	}
	
	public static function isString(c:Constant):Bool {
		return (c.getName() == 'CString');
	}
	
	public static function isIdent(c:Constant):Bool {
		return (c.getName() == 'CIdent');
	}
	
	public static function isEReg(c:Constant):Bool {
		return (c.getName() == 'CRegexp');
	}
	
	public static function isWildcard(c:Constant):Bool {
		return (c.get() == '_');
	}
	
}