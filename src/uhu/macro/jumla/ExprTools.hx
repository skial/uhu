package uhu.macro.jumla;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import uhu.macro.jumla.TypeParamTools;
import uhu.macro.jumla.expr.ConstantTools;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */

class ExprTools {
	
	public static function clean(e:Expr):Expr {
		if (e == null) return e;
		
		var result = e;
		
		switch (e.expr) {
			case EConst(c):
				result = { expr:EConst( c.clean() ), pos:e.pos };
			
			case EArray(e1, e2):
				result = { expr:EArray( e1.clean(), e2.clean() ), pos:e.pos };
			
			case EBinop(op, e1, e2):
				result = { expr:EBinop( op, e1.clean(), e2.clean() ), pos:e.pos };
			
			case EField(e, field):
				result = { expr:EField( e.clean(), field ), pos:e.pos };
			
			case EParenthesis(e):
				result = { expr:EParenthesis( e.clean() ), pos:e.pos };
			
			case EObjectDecl(fields):
				result = { expr:EObjectDecl( [for (f in fields) { field:f.field, expr:f.expr.clean() }] ), pos:e.pos };
			
			case EArrayDecl(values):
				result = { expr:EArrayDecl( [for (value in values) value.clean()] ), pos:e.pos };
			
			case ECall(e, params):
				result = { expr:ECall( e.clean(), [for (p in params) p.clean()] ), pos:e.pos };
			
			case ENew(t, params):
				result = { expr:ENew( t.clean(), [for (p in params) p.clean()] ), pos:e.pos };
			
			case EUnop(op, p, e):
				result = { expr:EUnop( op, p, e.clean() ), pos:e.pos };
			
			case EVars(vars):
				var new_vars = [];
				for (v in vars) {
					v.expr = v.expr.clean();
					new_vars.push( v );
				}
				result = { expr:EVars( new_vars ), pos:e.pos };
			
			case EFunction(name, f):
				result = { expr:EFunction( name, f.clean() ), pos:e.pos };
			
			case EBlock(values):
				result = { expr:EBlock( [for (value in values) value.clean()] ), pos:e.pos };
			
			case EFor(it, e):
				result = { expr:EFor( it.clean(), e.clean() ), pos:e.pos };
			
			case EIn(e1, e2):
				result = { expr:EIn( e1.clean(), e2.clean() ), pos:e.pos };
			
			case EWhile(e1, e2, b):
				result = { expr:EWhile( e1.clean(), e2.clean(), b ), pos:e.pos };
			
			case ESwitch(e, cases, ed):
				var new_cases = [];
				for (c in cases) {
					c.expr = c.expr.clean();
					new_cases.push( c );
				}
				result = { expr:ESwitch( e.clean(), new_cases, ed.clean() ), pos:e.pos };
			
			case ETry(e, catches):
				var new_catches = [];
				for (c in catches) {
					c.expr = c.expr.clean();
					new_catches.push( c );
				}
				result = { expr:ETry( e.clean(), new_catches ), pos:e.pos };
			
			case EReturn(e):
				result = { expr:EReturn( e.clean() ), pos:e.pos };
			
			case EBreak:
				
			case EContinue:
				
			case EUntyped(e):
				result = { expr:EUntyped( e.clean() ), pos:e.pos };
			
			case EThrow(e):
				result = { expr:EThrow( e.clean() ), pos:e.pos };
			
			case ECast(e, t):
				result = { expr:ECast( e.clean(), t ), pos:e.pos };
			
			case EDisplay(e, b):
				result = { expr:EDisplay( e.clean(), b ), pos:e.pos };
			
			case EDisplayNew(_):
				
			case ETernary(e1, e2, e3):
				result = { expr:ETernary( e1.clean(), e2.clean(), e3.clean() ), pos:e.pos };
			
			case ECheckType(e, t):
				result = { expr:ECheckType( e.clean(), t ), pos:e.pos };
			
			case EMeta(s, e):
				var new_params = [];
				for (p in s.params) {
					p = p.clean();
					new_params.push( p );
				}
				result = { expr:EMeta( s, e.clean() ), pos:e.pos };
				
			case _:
				
		}
		
		return result;
	}

	public static inline function toString(e:Expr):String {
		return e.printExpr();
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
				
			case [EBlock( b1), _]:
				result = EBlock( b1.concat( [ expr2 ] ) );
				
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
				result = EBlock( [expr1, expr2] );
				//throw 'Both expressions need to be of type [EArrayDecl, EBlock, EFunction, EObjectDecl or EVars].';
		}
		
		return { expr:result, pos:expr1.pos };
	}
	
	public static function split(exprs:Array<Expr>, delimiter:String):Array<Array<Expr>> {
		var result:Array<Array<Expr>> = [];
		
		var copy = exprs.copy();
		var previous = 0;
		var counter = 0;
		while (copy.length > 0) {
			
			var c = copy.shift();
			
			if (c != null) {
				
				var isSame = c.expr.getName() == delimiter;
				var isEnd = counter == exprs.length - 1;
				var call = (isSame && !isEnd) ? exprs.slice : exprs.splice;
				
				if (previous != null && (isSame || isEnd)) {
					
					var val = call( previous, counter );
					if ( val.length > 0 ) result.push( val );
					previous = null;
					
				}
				
				if (isSame && previous == null) previous = counter + 1;
				
			}
			
			++counter;
			
		}
		
		return result;
	}
	
	public static function indexOf(exprs:Array<Expr>, name:String, ?startIndex:Int = 0):Int {
		var result = -1;
		
		while (startIndex <= exprs.length - 1) {
			
			if (exprs[startIndex].expr.getName() == name) {
				result = startIndex;
				break;
			}
			
			startIndex++;
			
		}
		
		return result;
	}
	
	public static function typeof(expr:Expr):Type {
		var result:Type = null;
		/*try {
			
			result = Context.typeof( expr );
			
		} catch (e:Dynamic) {*/
			
			switch (expr.expr) {
				case EBinop(op, e1, e2): result = e2.typeof();
				case EUnop(op, p, e): result = e.typeof();
				case EField(e, _): result = e.typeof();
				case EVars(v): result = v.pop().expr.typeof();
				case EFunction(_, f): result = f.ret.toType();
				case EBlock(es): result = es.pop().typeof();
				case EReturn(e) if (e != null):  result = e.typeof();
				case ECast(_, t) if (t != null): result = t.toType();
				case EMeta(_, e): result = e.typeof();
				case ENew(t, _): result = Context.getType( t.path() );
				case _: 
					trace( expr );
					trace( expr.printExpr() );
			}
			
		//}
		
		return result;
	}
	
}