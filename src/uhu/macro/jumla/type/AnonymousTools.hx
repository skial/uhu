package uhu.macro.jumla.type;

import haxe.macro.ComplexTypeTools;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class AnonymousTools {

	public static function toTypeDefinition(anon:AnonType):TypeDefinition {
		var result:TypeDefinition = null;
		
		if (anon != null) {
			
			var fields = anon.fields.toFields();
			
			for (field in fields) {
				
				field.access = [];
				switch (field.kind) {
					case FVar(t, _):
						t = t.qualify();
						field.kind = FVar(t, null);
					case _:
				}
			}
			
			result = {
				pack: [],
				name: '',
				pos: Context.currentPos(),
				meta: [],
				params: [],
				isExtern: false,
				kind: TDStructure,
				fields: fields
			}
			
		}
		
		return result;
	}
	
}