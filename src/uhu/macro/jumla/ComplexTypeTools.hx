package uhu.macro.jumla;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import uhu.macro.jumla.expr.FieldTools;
import uhu.macro.jumla.t.TComplexString;

/**
 * ...
 * @author Skial Bainn
 */
 
class ComplexTypeTools {

	public static inline function toString(c:ComplexType):String {
		return Printer.printComplexType( c );
	}
	
	public static function toComplexString(c:ComplexType):TComplexString {
		var result = null;
		
		switch (c) {
			case TPath(p):
				
				result = TypePathTools.toComplexString( p );
				
			case TFunction(a, r):
				
				result = { name:'', params:[] };
				var names = [];
				
				for (i in a) {
					names.push( toComplexString( i ) );
				}
				
				names.push( toComplexString( r ) );
				
				result.name = names.join( '->' );
				
			case TAnonymous(f):
				
				result = FieldTools.toComplexString( f[0] );
				
			case TParent(t):
				
				result = toComplexString( t );
				
			case TExtend(p, _):
				
				result = TypePathTools.toComplexString( p );
				
			case TOptional(t):
				
				result = toComplexString( t );
		}
		
		return result;
	}
	
}