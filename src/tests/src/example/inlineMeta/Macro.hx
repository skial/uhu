package example.inlineMeta;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class Macro
{

	public static function build() {
		var fields = Context.getBuildFields();
		
		for (field in fields) {
			
			switch (field.kind) {
				case FFun(method):
					if (method.expr != null) {
						
						loop( method.expr );
						
					}
					
				case _:
			}
			
		}
		
		return fields;
	}
	
	public static function loop(e:Expr) {
		switch(e.expr) {
			case EMeta(s, e):
				trace(s);
				trace(e);
			case EBlock(exprs):
				
				for (expr in exprs) loop( expr );
				
			
			case _:
				
		}
	}
	
}