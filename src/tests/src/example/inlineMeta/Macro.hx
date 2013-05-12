package example.inlineMeta;

import haxe.macro.Printer;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class Macro {
	
	public static var fields:Array<Field> = [];

	public static function build() {
		fields = Context.getBuildFields();
		
		for (field in fields) {
			
			switch (field.kind) {
				case FFun(method):
					if (method.expr != null) {
						
						method.expr = loop( method.expr );
						
					}
					
				case _:
			}
			
		}
		
		return fields;
	}
	
	public static function loop(e:Expr, ?body:Array<Expr>) {
		var pos = e.pos;
		var result = e;
		var printer = new Printer();
		
		switch(e.expr) {
			case EMeta(s, e):
				if (s.name == ':wait' && s.params.length > 0) {
					
					result = loop( modify( e , s.params, body ) );
					
				}
				
			case EBlock(exprs):
				
				var i = 0;
				
				for (expr in exprs) {
					++i;
					result = loop( expr, exprs.slice( i ) );
					
					if ( printer.printExpr( result ) != printer.printExpr( expr ) ) {
						break;
					}
					
				}
				
				if ( printer.printExpr( result ) != printer.printExpr( e ) ) {
					exprs = exprs.slice(0, i);
					
					result = { expr:EBlock(exprs), pos:pos };
					
				}
				
			case ECall(e, p):
				var params:Array<Expr> = [];
				
				for (pp in p) {
					params.push( loop( pp ) );
				}
				
				result = { expr:ECall( loop( e ), params ), pos:pos };
				
			case EFunction(n, f):
				
				f.expr = loop( f.expr );
				
			case _:
				//trace( e );
		}
		
		return result;
	}
	
	public static function modify(e:Expr, params:Array<Expr>, body:Array<Expr>) {
		var pos = e.pos;
		var result = e;
		var printer = new Printer();
		
		switch (e.expr) {
			case ECall(e, p):
				
				var method = Context.parse('function(${printer.printExpr( params[0] )}, ${printer.printExpr( params[1] )}) {}', e.pos);
				p.push( modify( method, [], body ) );
				
				result = { expr:ECall(e, p), pos:pos };
				
			case EFunction(n, f):
				f.expr = { expr:EBlock( body ), pos:f.expr.pos };
				
				result = { expr:EFunction(n, f), pos:pos };
				
			case _:
				
		}
		
		return result;
	}
	
}