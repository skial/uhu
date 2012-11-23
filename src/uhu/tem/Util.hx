package uhu.tem;

import haxe.macro.Type;

using Detox;
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
	
	public static function hasBinding(element:DOMNode, value:String, isStatic:Bool) {
		return element.attr(isStatic ? Common.x_static : Common.x_instance).indexOf(value) != -1;
	}
	
	public static function addBinding(element:DOMNode, value:String, isStatic:Bool) {
		var attr = isStatic ? Common.x_static : Common.x_instance;
		var prev = element.attr(attr);
		
		if (prev == '') {
			element.setAttr(attr, value);
		} else if ( !Util.hasBinding(element, value, isStatic) ) {
			var old = prev.split(' ');
			old.push(value);
			element.setAttr(attr, old.join(' '));
		}
		
	}
	
	public static function removeBinding(element:DOMNode, value:String, isStatic:Bool) {
		var attr = isStatic ? Common.x_static : Common.x_instance;
		var prev = element.attr(attr).split(' ');
		prev.remove(value);
		element.setAttr(attr, prev.join(' '));
	}
	
}