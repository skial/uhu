package uhu.macro.jumla.type;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using StringTools;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class TypedefTools {
	
	public static function toTypeDefKind(def:DefType):TypeDefKind {
		return TDStructure;
	}

	public static function toTypeDefinition(def:DefType, prefix:String = '', suffix:String = ''):TypeDefinition {
		var pack = def.pack;
		
		if (def.isPrivate) {
			pack[0] = pack[0].substr( 1 );
		}
		
		var fields:Array<Field> = [];
		
		switch( def.type ) {
			case TAnonymous(a):
				fields = a.get().fields.toFields();
				
				for (field in fields) {
					
					field.access = [];
					switch (field.kind) {
						case FVar(t, _):
							field.kind = FVar(t, null);
						case _:
					}
				}
			case _:
				trace(def.type);
		}
		
		return {
			pack: pack,
			name: prefix + def.name + suffix,
			pos: def.pos,
			meta: def.meta.get(),
			params: def.toTypeParamDecls(),
			isExtern: def.isExtern,
			kind: def.toTypeDefKind(),
			fields: fields
		}
	}
	
}