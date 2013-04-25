package uhu.macro.jumla.type;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class EnumTypeTools {
	
	public static function toFields(e:EnumType):Array<Field> {
		var result:Array<Field> = e.constructs.toFields();
		
		for (name in e.names) {
			if (!result.exists( name ) ) {
				result.push( {
					name: name,
					kind: FVar( null, null ),
					pos: e.pos
				} );
			}
		}
		
		return result;
	}

	public static function toTypeDefinition(e:EnumType, prefix:String = '', suffix:String = ''):TypeDefinition {
		var pack = e.pack;
		
		if (e.isPrivate) {
			pack[0] = pack[0].substr( 1 );
		}
		
		return {
			pack: pack,
			name: prefix + e.name + suffix,
			pos: e.pos,
			meta: e.meta.get(),
			params: e.toTypeParamDecls(),
			isExtern: e.isExtern,
			kind: TDEnum,
			fields: e.toFields()
		}
	}
	
}