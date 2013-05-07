package uhx.macro;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class PubSubHelper {

	public static function create__init__():Field {
		return {
			meta: [],
			doc: null,
			pos: Context.currentPos(),
			name: '__init__',
			access: [APublic, AStatic],
			kind: FFun( {
				args: [],
				ret: null,
				expr: macro { },
				params: []
			} )
		};
	}
	
}