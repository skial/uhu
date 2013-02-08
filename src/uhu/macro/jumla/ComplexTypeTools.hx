package uhu.macro.jumla;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import uhu.macro.jumla.t.TComplexString;

/**
 * ...
 * @author Skial Bainn
 */
 
class ComplexTypeTools {

	public static inline function toString(c:ComplexType):String {
		return Printer.printComplexType( c );
	}
	
	public static function toType(c:ComplexType):TComplexString {
		var result = null;
		
		switch (c) {
			case TPath(p):
				
				result = TypePathTools.toType( p );
				
			case TFunction(a, r):
				
				result = { name:'', params:[] };
				var names = [];
				
				for (i in a) {
					names.push( toType( i ) );
				}
				
				names.push( toType( r ) );
				
				result.name = names.join( '->' );
				
			case TAnonymous(f):
				
				result = FieldTools.toType( f[0] );
				
			case TParent(t):
				
				result = toType( t );
				
			case TExtend(p, f):
				
				result = TypePathTools.toType( p );
				
			case TOptional(t):
				
				result = toType( t );
		}
		
		return result;
	}
	
}