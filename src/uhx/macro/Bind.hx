package uhx.macro;

import haxe.ds.StringMap;
import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class Bind {

	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		for (field in fields) {
			
			switch (field.kind) {
				case FFun(method):
					loop( method.expr.expr );
					
				case _:
			}
			
		}
		
		return fields;
	}
	
	private static function loop(expr:ExprDef) {
		
		switch (expr) {
			case EBlock(es):
				for (e in es ) loop( e.expr );
				
			case EVars(vars):
				for (v in vars) if (v.expr != null ) loop( v.expr.expr );
				
			case EBinop(op, e1, e2):
				switch (e1.expr) {
					case EMeta(s, e):
						trace( op );
						trace( s );
						trace( e );
						trace( e2 );
						
					case _:
				}
				
			case _:
				//trace( expr );
		}
		
	}
	
}