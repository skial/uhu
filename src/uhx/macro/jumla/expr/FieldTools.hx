package uhx.macro.jumla.expr;

import haxe.macro.Type;
import haxe.macro.Expr;
import uhx.macro.jumla.a.AField;
import uhx.macro.jumla.a.AFields;

using Lambda;
using uhx.macro.Jumla;
/**
 * ...
 * @author Skial Bainn
 */
class FieldTools {

	public static function sugar(t:Field):AField return t;
	
}

class ManyFieldTools {

	public static inline function sugar(t:Array<Field>):AFields return t;
	
	public static function exists(fields:Array<Field>, name:String):Bool {
		var result:Bool = false;
		
		for (field in fields) if (field.name == name) {
			result = true;
			break;
		}
		
		return result;
	}

	public static function get(fields:Array<Field>, name:String):Field {
		var result:Field = null;
		
		for (field in fields) if (field.name == name) {
			result = field;
			break;
		}
		
		return result;
	}
	
	public static function remove(fields:Array<Field>, name:String):Bool {
		return fields.remove( get( fields, name ) );
	}
	
}

class FieldCollection {
	
	public static function meta(v:ManyFields, key:String):Array<AField> {
		return Lambda.filter(v.original, function(f) return f.meta.exists( key ) ).array();
	}
	
	public static function access(v:ManyFields, key:Access):Array<AField> {
		return Lambda.filter(v.original, function(f) return f.access.exists( key ) ).array();
	}
	
	public static function kind(v:ManyFields, key:FieldType):Array<AField> {
		var result = false;
		
		Lambda.filter(v.original, function(f) {
			switch (f.kind) {
				case FVar(t, e) if(key.getName() == 'FVar'):
					if (key.getParameters()[0] != null) {
						
					}
					
				case FProp(g, s, t, e) if(key.getName() == 'FProp'):
					if (key.getParameters()[2] != null) {
						
					}
					
				case FFun(m) if(key.getName() == 'FFun'):
					if (key.getParameters()[0] != null) {
						
					}
					
				case _:
			}
		} );
		
		return result;
	}
	
}