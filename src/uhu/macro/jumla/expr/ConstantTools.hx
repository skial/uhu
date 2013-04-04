package uhu.macro.jumla.expr;

import haxe.macro.Expr;
import uhu.macro.jumla.t.TComplexString;

using StringTools;
using haxe.EnumTools;

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
		return Printer.printConstant( c );
	}
	
	public static function toComplexString(c:Constant):TComplexString {
		var result:TComplexString = null;
		
		switch (c) {
			case CInt(_):
				result = { name:'Int', params:[] };
			case CFloat(_):
				result = { name:'Float', params:[] };
			case CString(_):
				result = { name:'String', params:[] };
			case CIdent(s):
				trace('ident');
				trace(s);
				result = { name:s, params:[] };
			case CRegexp(_, _):
				result = { name:'EReg', params:[] };
		}
		
		return result;
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
	
}