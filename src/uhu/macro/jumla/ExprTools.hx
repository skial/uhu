package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.TypeParamTools;
import uhu.macro.jumla.t.TComplexString;

/**
 * ...
 * @author Skial Bainn
 */

class ExprTools {

	public static inline function toString(e:Expr):String {
		return Printer.printExpr( e );
	}
	
	public static function toType(e:Expr):TComplexString {
		var result = null;
		
		switch (e.expr) {
			case EArrayDecl(_) | EArray(_, _):
				result = { name:'Array', params:[] };
				
			case EConst(c):
				result = ConstantTools.toType( c );
				
			case ENew(t, _):
				result = TypePathTools.toType( t );
				
			case EObjectDecl(_):
				result = { name:'Typedef', params:[] };
				
			case _:
				
		}
		
		return result;
	}
	
	@:extern public static inline function merge(expr1:Expr, expr2:Expr):Expr {
		return concat( expr1, expr2 );
	}
	
	public static function concat(expr1:Expr, expr2:Expr):Expr {
		var result = null;
		
		switch ( [expr1.expr, expr2.expr] ) {
			case [EArrayDecl( v1 ), EArrayDecl( v2 )]:
				result = EArrayDecl( v1.concat( v2 ) );
				
			case [EBlock( b1 ), EBlock( b2 )]:
				result = EBlock( b1.concat( b2 ) );
				
			case [EFunction( n1, m1 ), EFunction( _, m2 )]:
				if (m1.expr == null && m2.expr == null) {
					throw 'One or both of the functions bodies are empty or null.';
				}
				
				m1.args = m1.args.concat( m2.args );
				m1.params = m1.params.concat( m2.params );
				m1.expr = concat( m1.expr, m2.expr );
				result = EFunction( n1, m1 );
				
			case [EObjectDecl( f1 ), EObjectDecl( f2 )]:
				result = EObjectDecl( f1.concat( f2 ) );
				
			case [EVars( v1 ), EVars( v2 )]:
				result = EVars( v1.concat( v2 ) );
				
			case _:
				throw 'Both expressions need to be of type [EArrayDecl, EBlock, EFunction, EObjectDecl or EVars].';
		}
		
		return { expr:result, pos:expr1.pos };
	}
	
}