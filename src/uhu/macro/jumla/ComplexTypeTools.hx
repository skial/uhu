package uhu.macro.jumla;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import uhu.macro.jumla.expr.FieldTools;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
 
class ComplexTypeTools {
	
	public static inline function toType(c:ComplexType):Type {
		return haxe.macro.ComplexTypeTools.toType( c );
	}
	
	public static function qualify(c:ComplexType):ComplexType {
		var type = haxe.macro.ComplexTypeTools.toType( c );
		type = Context.follow( type );
		var result = Context.toComplexType( type );
		
		/*var result = c;
		if (c == null) return c;
		
		switch(c) {
			case TPath(p):
				result = TPath( p.qualify() );
				
			case TFunction(args, ret):
				var nargs:Array<ComplexType> = [];
				
				for (arg in args) {
					nargs.push( arg.qualify() );
				}
				
				result = TFunction( nargs, ret.qualify() );
				
			case TAnonymous(fields):
				var nfields:Array<Field> = [];
				
				for (field in fields) nfields.push( field.qualify() );
				
				result = TAnonymous( nfields );
				
			case TParent(t):
				result = TParent( t.qualify() );
				
			case TExtend(p, f):
				result = TExtend( p.qualify(), f );
				
			case TOptional(t):
				result = TOptional( t.qualify() );
		}*/
		
		return result;
	}

	public static inline function toString(c:ComplexType):String {
		return c.printComplexType();
	}
	
}