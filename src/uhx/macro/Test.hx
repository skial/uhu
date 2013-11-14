package uhx.macro;

import haxe.macro.Type;
import haxe.macro.Expr;

using uhx.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class Test {

	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		//trace( cls.sugar().ancestors.fmeta.get( ':db' ) );
		trace( cls.sugar().ancestors.filter.by.meta( ':db' ) );
		//trace( fields.sugar().fmeta.get( ':skip' ) );
		trace( fields.sugar().filter.by.meta( ':skip' ) );
		trace( fields.sugar().filter.by.access( AStatic ) );
		trace( fields.sugar().filter.by.kind( FVar(macro:Array<String>) ) );
		return fields;
	}
	
}