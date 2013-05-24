package example.namedArgs;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using StringTools;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class Macro {

	public static function build() {
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		
		for (field in fields) {
			
			switch (field.kind) {
				
				case FFun(method):
					
					method.expr = loop( method.expr );
					
				case _:
				
			}
			
		}
		
		return fields;
	}
	
	public static function loop(e:Expr):Expr {
		var result = e;
		
		switch (e.expr) {
			case EBlock(exprs):
				
				result = { expr:EBlock( [for (expr in exprs) loop( expr )] ), pos: e.pos };
				
			case ECall(expr, params):
				
				var copy = params.copy();
				
				var matches:Array<{e:Expr, n:String, pos:Int}> = [];
				
				for (i in 0...params.length) {
					
					var val:Expr = params[i];
					
					if (val.expr.getName() == 'EMeta') {
						
						var type = expr.printExpr().find();
						var arity = type.arity();
						var args = type.args();
						
						var meta:MetadataEntry = val.expr.getParameters()[0];
						var name:String = meta.name.replace(':', '');
						
						matches.push( { e: val, n: name , pos: args.indexOf( name ) } );
						
						copy = copy.splice(0, i).concat( copy.splice(i + 1, -1) );
						
					}
					
				}
				
				for (match in matches) {
					
					if (match.pos == -1) {
						trace( match );
					}
					
					while (match.pos > copy.length - 1) {
						
						copy.push(macro null);
						
					}
					
					copy[match.pos] = match.e.expr.getParameters()[1];
					
				}
				
				result = { expr: ECall( expr, copy ), pos: e.pos };
				
			case _:
				trace( e );
		}
		
		return result;
	}
	
}