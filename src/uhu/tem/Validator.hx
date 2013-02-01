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
using Iterators;
using Lambda;
using StringTools;

/**
 * ...
 * @author Skial Bainn
 */

class Validator {
	
	public static var currentElement:Xml = null;

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
		
		//trace(field);
		
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
		
		//trace(complex_str);
		
		if (complex_str != null) {
			
			var children:DOMCollection;
			var valid:DOMCollection;
			
			switch (complex_str.name) {
				case 'String' | 'Dynamic':
					
					// Get all child elements, thats dom nodes, text nodes and comments.
					children = currentElement.children(false);
					
					if (children.length == 0) {
						throw 'The current element does not have any child nodes : $currentElement';
					}
					
					
				case 'Float' | 'Int':
					
					children = currentElement.children(false);
					valid = new DOMCollection();
					
					if (children.length == 0) {
						throw 'The current element does not have any child nodes : $currentElement';
					}
					
					for (c in children) {
						if (c.isTextNode()) {
							valid.add(c);
						}
					}
					
					if (valid.length == 0) {
						throw 'No text nodes exist.';
					}
					
					var func = complex_str.name == 'Float' ? Std.parseFloat : Std.parseInt;
					
					try {
						var value = func( valid.first().val() );
					} catch (e:Dynamic) {
						throw '${valid.first().val()} can not be cast to Float';
					}
					
				case 'Bool':
					
					// Based on HTML5 spec - This gives quick overview http://stackoverflow.com/a/4140263
					
					var match = null;
					
					for (a in currentElement.attributes()) {
						
						if (a == 'data-${field.name}' || a == field.name) {
							match = a;
							break;
						}
						
					}
					
					if (match == null) {
						throw 'Can not find attribute "data-${field.name}" or "${field.name}" on $currentElement. This probably is a bug. Please create a minimal reproducible example and submit it to http://www.github.com/skial/uhu/issues';
					}
					
					var attr = currentElement.attr( match );
					var spec = ( attr == '' || attr.toLowerCase() == match.toLowerCase() );
					
					if ( !spec ) {
						throw 'Attribute "$match" matched with "${field.name}" of type "Bool" has a value of "$attr". Check http://stackoverflow.com/a/4140263 for valid HTML5 booleans.';
					}
					
				case 'Array' | 'List':
					
					if (complex_str.params[0] == null) {
						throw 'No type was detected for field "${field.name}" of type "Array<Unknown>"';
					}
					
					switch (complex_str.params[0].name) {
						case 'Dynamic' | 'String' | 'DOMNode' | 'Dom' | 'Xml':
						case _:
							throw 'Type "${complex_str.params[0].name}" for "${field.name}" is not compatiable. Available types are "Dynamic, String, DOMNode, Dom, Xml"';
					}
					
					children = currentElement.children(false);
					
					if (children.length == 0) {
						throw 'The current element does not have any child nodes : $currentElement';
					}
					
					var func = null;
					
					switch (complex_str.params[0].name) {
						case 'Dynamic' | 'String':
							func = function(ele:Xml) {
								
								if (ele.isTextNode() || ele.isComment() || ele.isElement()) {
									return true;
								}
								
								return false;
							}
						case 'DOMNode' | 'Dom' | 'Xml':
							func = function(ele:Xml) {
								
								if ( ele.isElement() ) {
									return true;
								}
								
								return false;
							}
					}
					
					valid = new DOMCollection();
					
					for (c in children) {
						
						if ( func(c) ) {
							valid.add( c );
						}
						
					}
					
					/*trace(field.name);
					trace(valid);*/
					
				case 'DOMNode' | 'Dom' | 'Xml':
					
					// hmm, dont think i need to check anything...
					
				case _:
					
					throw 'Type "${complex_str.name}" is currently not supported.';
			}
			
		}
		
		return true;
		
	}
	
	public static function method(field:TField) {
		
		switch (field.kind) {
			case FFun(_):
			default:
		}
		
	}
	
}