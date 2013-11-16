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
		trace( cls.sugar().ancestors.filter.by.meta( ':db' ).length );
		trace( fields.sugar().filter.by.meta( ':skip' ).length );
		trace( fields.sugar().filter.by.access( AStatic ).length );
		trace( fields.sugar().filter.by.type( macro:String ).length );
		trace( fields.sugar().filter.by.getter( 'get' ).length );
		trace( fields.sugar().filter.by.setter( 'never' ).length );
		trace( fields.sugar().filter.by.name( ~/get_/i ).length );
		trace( fields.sugar().filter.by.kind( FVar(null, null) ).length );
		return fields;
	}
	
}