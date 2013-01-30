package uhu.tem;

import dtx.XMLWrapper;
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;

import uhu.macro.jumla.t.TComplexString;
import uhu.tem.Common;
import uhu.tem.t.TemClass;
import uhu.tem.t.TemTemplate;

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
	
	public static function processXML(xml:Xml) {
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
	
	public static function fieldKind(field:TField) {
		
		switch (field.kind) {
			case FVar(_, _) | FProp(_, _, _, _):
				variable(field);
			case FFun(_):
				method(field);
		}
		
	}
	
	public static function variable(field:TField) {
		
		trace(field);
		
		var pair = switch(field.kind) {
			case FVar(t, e): { type:t, expr:e };
			case FProp(_, _, t, e): { type:t, expr:e };
			default: null;
		}
		
		var complex_str:TComplexString = null;
		
		if (pair != null) {
			
			if (pair.type != null) {
				complex_str = pair.type.toType();
			} else if (pair.expr != null) {
				complex_str = pair.expr.toType();
			}
			
		}
		
		trace(complex_str);
		
		if (complex_str != null) {
			
			switch (complex_str.name) {
				case 'String' | 'Dynamic':
					
					// Get all child elements, thats dom nodes, text nodes and comments.
					var children:DOMCollection = currentElement.children(false);
					
					for (c in children) {
						trace(c.isElement());
						trace(c.isTextNode());
						trace(c.isComment());
					}
					
					
				case 'Float' | 'Int':
					
				case 'Bool':
					
				case 'Array' | 'List':
					
				case 'DOMNode' | 'Dom' | 'Xml':
					
				case _:
			}
			
		}
		
	}
	
	public static function method(field:TField) {
		
		switch (field.kind) {
			case FFun(_):
			default:
		}
		
	}
	
}