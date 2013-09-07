package uhx.macro;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class EThis {

	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		for (field in fields) {
			if (!field.isStatic()) switch (field.kind) {
				case FFun(method):
					switch(method.expr.expr) {
						case EBlock(es):
							es.unshift( macro var ethis = this );
							
						case _:
					}
					
				case _:
			}
		}
		
		return fields;
	}
	
}