package example.methodName;

import haxe.macro.Printer;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class Macro {

	public static function build():Array<Field> {
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		
		for (field in fields) {
			switch (field.kind) {
				case FFun(f):
					
					f.expr = loop( f.expr );
					
				case _:
					
			}
		}
		
		return fields;
	}
	
	private static function loop(e:Expr):Expr {
		var result = e;
		
		switch (e.expr) {
			case EVars(vars):
				var nvars = [];
				
				for (v in vars) {
					if (v.expr != null) v.expr = loop( v.expr );
					nvars.push( v );
				}
				
				result.expr = EVars( nvars );
				
			case ECall(expr, params):
				result.expr = ECall( loop( expr ), [for (p in params) loop( p ) ] );
				
			case EMeta(meta, expr):
				var name = new Printer().printExpr( expr );
				result = macro new Callback2( { method:$expr, name:$v{name} } );
				
			case EBlock(exprs):
				result.expr = EBlock( [for (ex in exprs) loop(ex)] );
				
			case _:
				
		}
		
		return result;
	}
	
}