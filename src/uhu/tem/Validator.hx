package uhu.tem;

import dtx.XMLWrapper;
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;
import uhu.macro.jumla.typedefs.TComplexString;
import uhu.tem.Common;

using uhu.macro.Jumla;
using uhu.tem.Util;
using Detox;
using Lambda;
using StringTools;

/**
 * ...
 * @author Skial Bainn
 */

class Validator {
	
	private static var currentElement:Xml = null;

	public static function parse(xml:Xml) {
		
		for (x in xml) {
			try {
				processXML(x);
			} catch (e:Dynamic) { }
		}
		
		return xml;
	}
	
	private static function processXML(xml:Xml) {
		var fields:Array<String>;
		
		if ( xml.exists(Common.x_instance) ) {
			
			currentElement = xml;
			fields = xml.attr(Common.x_instance).split(' ');
			
			for (field in fields) {
				
				var pack:Array<String> = field.split('.');
				var name:String = pack.pop();
				var mfield = Common.currentFields.getClassField(name);
				
				fieldKind(mfield);
				
			}
			
		}
		
		if ( xml.exists(Common.x_static) ) {
			
			currentElement = xml;
			var field = xml.attr(Common.x_static).split(' ')[0];
			
			var pack:Array<String> = field.split('.');
			var name:String = pack.pop();
			var mfield = Common.currentStatics.getClassField(name);
			
			fieldKind(mfield);
			
		}
		
		for (c in xml.children()) {
			processXML(c);
		}
	}
	
	private static function fieldKind(field:Field) {
		
		switch (field.kind) {
			case FVar(_, _) | FProp(_, _, _, _):
				variable(field);
			case FFun(_):
				method(field);
		}
		
	}
	
	private static function variable(field:Field) {
		
		var pair = switch(field.kind) {
			case FVar(t, e): { type:t, expr:e };
			case FProp(_, _, t, e): { type:t, expr:e };
			default: null;
		}
		
		var complex_str:TComplexString = null;
		
		if (pair != null) {
			complex_str = if (pair.type != null) {
				pair.type.itsType();
			} else if (pair.expr != null) {
				pair.expr.itsType();
			}
		}
		
		trace(complex_str);
		
		if (complex_str != null) {
			
			switch (complex_str.name) {
				case 'String' | 'Dynamic':
					
					trace(currentElement);
					
					for (c in currentElement.children(false)) {
						trace(c.isElement());
					}
					
					
				case 'Float' | 'Int':
					
				case 'Bool':
					
				case 'Array' | 'List':
					
				case 'DOMNode' | 'Dom' | 'Xml':
					
				case _:
			}
			
		}
		
	}
	
	private static function method(field:Field) {
		
		switch (field.kind) {
			case FFun(kind):
			default:
		}
		
	}
	
}