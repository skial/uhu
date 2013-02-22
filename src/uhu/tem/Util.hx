package uhu.tem;

import haxe.macro.Type;
import haxe.macro.Expr;

import uhu.tem.t.TemClass;
import uhu.tem.t.TemTemplate;

using Detox;
using Lambda;
using StringTools;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */

class Util {
	
	// rename to hasField?
	public static inline function hasClassField(fields:Array<TField>, name:String):Bool {
		return fields.exists( name );
	}
	
	// rename to getField?
	public static function getClassField(fields:Array<TField>, name:String):Null<TField> {
		
		for (f in fields) {
			if (f.name == name) return f;
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