package uhu.tem;

import haxe.macro.Context;
import selecthxml.SelectDom;
import uhu.macro.Du;
import Xml;
import haxe.xml.Parser;
import thx.html.Html;
import uhu.tem.Common;
import haxe.macro.Expr;
import haxe.macro.Type;

using uhu.tem.Util;
using de.polygonal.core.fmt.ASCII;
using Lambda;
using Detox;
using uhu.Library;
using selecthxml.SelectDom;
using tink.core.types.Outcome;
using tink.macro.tools.MacroTools;

/**
 * ...
 * @author Skial Bainn
 */

class Parser {
	
	private static var classElements:Hash<Array<Xml>> = new Hash<Array<Xml>>();
	private static var foundClasses:Array<String> = new Array<String>();
	
	private static var idElements:Hash<Array<Xml>> = new Hash<Array<Xml>>();
	private static var foundIds:Array<String> = new Array<String>();
	
	private static var haxeClasses:Hash<TemClass> = new Hash<TemClass>();
	
	private static function matchCSS(css:String, element:Xml, id:Bool) {
		var resolved = null;
		var found = id ? foundIds : foundClasses;
		var elements = id ? idElements : classElements;
		
		if (Common.ignoreClass.indexOf(css) != -1) {
			return;
		}
		
		// Find the matching Haxe class. Will be `null` more often than not.
		resolved = Common.userClasses.get(css);
		
		if (resolved != null) {
			
			css = resolved.cls.pack.join('.') + '.' + resolved.cls.name;
			
			found.push(css);
			
			// Set the Haxe class to resolve to the css class if not already done.
			if (!haxeClasses.exists(css)) {
				haxeClasses.set(css, resolved);
			}
			// Set or add to the array of elements that have this class name.
			if (!elements.exists(css)) {
				elements.set(css, [element]);
			} else {
				elements.get(css).push(element);
			}
			
		}
	}
	
	private static function matchField(css:String, element:Xml, isStatic:Bool = false) {
		if (Common.ignoreClass.indexOf(css) != -1) {
			return;
		}
		
		// Find the matching field from last matched class, backwards until found or non match.
		//var classes = isStatic ? foundIds.copy() : foundClasses.copy();
		var classes = findParents(element, isStatic ? 'id' : 'class' );
		var tem:TemClass;
		var fields:Array<ClassField>;
		var path:String;
		var attribute:String = 'x-binding' + (isStatic ? '-static' : '');
		var field:ClassField;
		var values:Array<String>;
		
		classes.reverse();
		
		for (c in classes) {
			
			if (!haxeClasses.exists(c)) continue;
			
			tem = haxeClasses.get(c);
			
			fields = isStatic ? tem.cls.statics.get() : tem.cls.fields.get();
			
			field = fields.getClassField(css);
			
			if (field == null) continue;
			
			if (element.attr(attribute) == '') {
				element.setAttr(attribute, tem.name + '.' + field.name);
			} else {
				values = element.attr(attribute).split(' ');
				values.push(tem.name + '.' + field.name);
				element.setAttr(attribute, values.join(' '));
			}
			
		}
		
	}
	
	private static function findParents(element:Xml, type:String) {
		// Change type to enum??
		var result:Array<String> = [];
		var attribute:String;
		
		// Not sure if pulling all possibly valid class names on current element is needed. Problem point.
		if ( type == 'class' && element.attr(type) != '' ) {
			
			attribute = element.attr(type);
			
			for (attr in attribute.split(' ')) {
				
				if ( attr.charCodeAt(0).isUpperCaseAlphabetic() && Common.userClasses.exists(attr) ) {
					result.push( Common.userClasses.get(attr).name );
				}
				
			}
			
		}
		
		for (p in element.ancestors()) {
			
			if (p.attr(type) != '') {
				attribute = p.attr(type);
				if ( type == 'id' ) {
					
					attribute = attribute.split(' ')[0];
					
					if ( attribute.split(' ')[0].charCodeAt(0).isUpperCaseAlphabetic() && Common.userClasses.exists(attribute.split(' ')[0]) ) {
						result.push( Common.userClasses.get(attribute.split(' ')[0]).name );
					}
					
				} else if ( type == 'class' ) {
					
					for (attr in attribute.split(' ')) {
						
						if ( attr.charCodeAt(0).isUpperCaseAlphabetic() && Common.userClasses.exists(attr) ) {
							result.push( Common.userClasses.get(attr).name );
						}
						
					}
					
				}
			}
			
		}
		
		return result;
	}
	
	private static function processXML(x:Xml) {
		var names:Array<String>;
		
		if (x.attr('class') != '') {
			
			names = x.attr('class').split(' ');
			
			for (name in names) {
				
				// If the first letter is uppercase then its assumed to be
				// a possible Haxe class, otherwise a possible field.
				if ( name.charCodeAt(0).isUpperCaseAlphabetic() ) {
					matchCSS(name, x, false);
				} else {
					matchField(name, x, false);
				}
				
			}
			
		}
		
		if (x.attr('id') != '') {
			
			names = x.attr('id').split(' ');
			
			// If the first letter is uppercase then its assumed to be
				// a possible Haxe class, otherwise a possible field.
			if ( names[0].charCodeAt(0).isUpperCaseAlphabetic() ) {
				matchCSS(names[0], x, true);
			} else {
				matchField(names[0], x, true);
			}
			
		}
		
		for (c in x.children()) {
			processXML(c);
		}
		
	}

	public static function parse(html:String) {
		var xml:Xml = Html.toXml(html);
		var elements:Array<Xml>;
		
		for (x in xml) {
			processXML(x);
		}
		
		//trace(Util.select(xml, '[x-binding]'));
		//trace(Util.select(xml, '[x-binding-static]'));
		trace(xml.runtimeSelect('[x-binding]'));
		trace(xml.runtimeSelect('[x-binding-static]'));
		
		return xml;
	}
	
}

class Class1 {
	public function new() { }
	public function format() {}
}

class MyClass {
	public function new() { }
	public function fields() { }
	public static var myField = 0;
}

class YourClass {
	public static function yourField() {}
}