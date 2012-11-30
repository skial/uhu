package uhu.macro;

import Type in StdType;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */

/**
 * Swahili for macro, I think
 */
class Jumla {
	
	public static function getClass(name:String):Null<{cls:ClassType, params:Array<Type>}> {
		switch (Context.getType(name)) {
			case TInst(c, p):
				return { cls:c.get(), params:p };
			default:
		}
		return null;
	}
	
	// Compat code for tink_macros
	@:extern public static inline function getID(type:haxe.macro.Type, ?reduce:Bool = false) {
		return getName(type);
	}
	
	public static function getName(type:haxe.macro.Type):String {
		switch (type) {
			case TInst(t, _):
				return t.toString();
			case TEnum(t, _):
				return t.toString();
			case TType(t, _):
				return t.toString();
			#if haxe3
			case TAbstract(t, _):
				return t.toString();
			#end
			default:
				
		}
		
		return '';
	}
	
	public static function fieldKind(field:ClassField):String {
		
		var result = '';
		
		switch (field.kind) {
			case FMethod(k):
				switch (k) {
					default:
						result = StdType.enumConstructor(k);
				}
			default:
				result = StdType.enumConstructor(field.kind);
		}
		
		return result;
	}
	
	public static function constValue(constant:Constant):String {
		
		var result:String = null;
		
		switch (constant) {
			case CInt( v ), CFloat( v ), CString( v ), CIdent( v ):
				result = v;
			case CRegexp( r, opt ):
				result = r + opt;
			#if !haxe3
			case CType( s ):
				result = s;
			#end
			default:
		}
		
		return result;
	}
	
	@:extern public static inline function toExpr(value:Dynamic, ?pos:Position) {
		return Context.makeExpr(value, pos);
	}
	
	/**
	 * This method just tries and finds a Constant enum.
	 */
	public inline static function findEConst(expr:Expr):Null<Constant> {
		var result = findExpr(expr, 'EConst');
		return (result != null) ? result[0] : null;
	}
	
	public inline static function findECall(expr:Expr):Null<{e:Expr, params:Array<Expr>}> {
		var result = findExpr(expr, 'ECall');
		return (result != null) ? { e:result[0], params:result[1] } : null;
	}
	
	public static function findEField(expr:Expr):Null<{e:Expr, field:String}> {
		var result = findExpr(expr, 'EField');
		return (result != null) ? {e:result[0], field:result[1]} : null;
	}
	
	public static function findExpr(expr:Expr, type:String):Null<Array<Dynamic>> {
		var result:Array<Expr> = null;
		
		while (true) {
			result = getExprs(expr);
			
			if (result != null && result.length != 0) {
				for (r in result) {
					if (StdType.enumConstructor(r.expr) == type) {
						return StdType.enumParameters(r.expr);
					} else {
						expr = r;
						break;
					}
				}
			}
		}
		
		return null;
	}

	/**
	 * This method just gathers all the Expr values and returns them.
	 * It doesnt care about the type the expr comes from. Useful to
	 * dig through nested values.
	 */
	public static function getExprs(expr:Expr):Null<Array<Expr>> {
		
		var result:Array<Expr> = [];
		
		switch (expr.expr) {
			case EConst( c ):
			case EArray( e1, e2 ):
				result = [e1, e2];
			case EBinop( op, e1, e2 ):
			case EField( e, field ):
				result = [e];
			case EParenthesis( e ):
				result = [e];
			case EObjectDecl( fields ):
				for (f in fields) {
					result.push(f.expr);
				}
			case EArrayDecl( values ):
				for (v in values) {
					result.push(v);
				}
			case ECall( e, params ):
				result = [e];
				for (p in params) {
					result.push(p);
				}
			case ENew( t, params ):
				for (p in params) {
					result.push(p);
				}
			case EUnop( op, postFix, e ):
			case EVars( vars ):
				for (v in vars) {
					if (v.expr != null) result.push(v.expr);
				}
			case EFunction( name, f ):
				if (f.expr != null) result = [f.expr];
			case EBlock( exprs ):
				for (e in exprs) {
					result.push(e);
				}
			case EFor( it, expr ):
			case EIn( e1, e2 ):
			case EIf( econd, eif, eelse ):
			case EWhile( econd, e, normalWhile ):
			case ESwitch( e, cases, edef ):
			case ETry( e, catches ):
			case EReturn( e ):
				if (e != null) result = [e];
			case EBreak:
			case EContinue:
			case EUntyped( e ):
				result = [e];
			case EThrow( e ):
				result = [e];
			case ECast( e, t ):
				result = [e];
			case EDisplay( e, isCall ):
				result = [e];
			case EDisplayNew( t ):
			case ETernary( econd, eif, eelse ):
			case ECheckType( e, t ):
				result = [e];
			#if !haxe3
			case EType( e, field ):
			#end
			default:
		}
		
		return result.length == 0 ? null : result;
		
	}
	
}