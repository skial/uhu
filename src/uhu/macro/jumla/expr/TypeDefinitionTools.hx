package uhu.macro.jumla.expr;

import haxe.macro.Expr;

/**
 * ...
 * @author Skial Bainn
 */
class TypeDefinitionTools {

	public static function path(t:TypeDefinition):String {
		return t.pack.join( '.' ) + (t.pack.length > 0 ? '.' : '') + t.name;
	}
	
}