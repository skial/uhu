package uhu.macro.jumla.type;

import haxe.ds.StringMap;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class EnumFieldTools {
	
	public static function toFieldType(field:EnumField):FieldType {
		var result = null;
		
		if (field.params.length == 0) {
			result = FVar( null, null );
		} else {
			var args:Array<FunctionArg> = [];
			for (p in field.params) {
				args.push( {
					name: p.name,
					opt: false,
					type: Context.toComplexType( p.t )
				} );
			}
			
			result = FFun( {
				args: args,
				ret: null,
				expr: null,
				params: []
			} );
		}
		
		return result;
	}

	public static function toField(field:EnumField):Field {
		return {
			name: field.name,
			kind: field.toFieldType(),
			pos: field.pos,
			meta: field.meta.get()
		}
	}
	
	public static function toFields(fields:StringMap<EnumField>):Array<Field> {
		var result:Array<Field> = [];
		
		for (field in fields) {
			result.push( field.toField() );
		}
		
		return result;
	}
	
}