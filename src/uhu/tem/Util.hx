package uhu.tem;

import haxe.macro.Type;

using Lambda;
using StringTools;
using tink.macro.tools.MacroTools;

/**
 * ...
 * @author Skial Bainn
 */

class Util {
	
	private static var last_field:ClassField = null;
	
	// rename to hasField?
	public static function hasClassField(fields:Array<ClassField>, name:String):Bool {
		return fields.exists( function(f) {
			if (f.name == name) {
				last_field = f;
				return true;
			}
			return false;
		} );
	}
	
	// rename to getField?
	public static function getClassField(fields:Array<ClassField>, name:String):Null<ClassField> {
		if (last_field != null && last_field.name == name) return last_field;
		
		if ( Util.hasClassField(fields, name) ) {
			return last_field;
		}
		
		return null;
	}
	
	public static function getFieldType(type:Type):String {
		var t = type.getID().trim();
		
		switch (t) {
			case 'Array':
				switch (type) {
					case TInst(_, p):
						return t + '::' + getFieldType(p[0]);
					default:
				}
			default:
		}
		
		return t;
		
	}
	
}