package uhu.vezati;

import haxe.macro.Context;
import selecthxml.SelectDom;
import uhu.macro.Du;
import Xml;
import haxe.xml.Parser;
import thx.html.Html;
import uhu.vezati.Common;

using de.polygonal.core.fmt.ASCII;
using Lambda;
using Detox;
using uhu.Library;
using selecthxml.SelectDom;

/**
 * ...
 * @author Skial Bainn
 */

class Parser {
	
	// private fields
	
	private static var classElements:Hash<Array<Xml>> = new Hash<Array<Xml>>();
	private static var foundClasses:Array<String> = new Array<String>();
	
	private static var idElements:Hash<Array<Xml>> = new Hash<Array<Xml>>();
	private static var foundIds:Array<String> = new Array<String>();
	
	private static var haxeClasses:Hash<Class<Dynamic>> = new Hash<Class<Dynamic>>();
	
	private static function matchClass(css:String, element:Xml) {
		var resolved = null;
		
		if (Common.ignoreNames.indexOf(css) != -1) {
			return;
		}
		
		// Find the matching Haxe class. Will be `null` more often than not.
		resolved = Type.resolveClass( Common.userClasses.exists(css) ? Common.userClasses.get(css) : css );
		
		if (resolved != null) {
			
			css = Type.getClassName(resolved);
			
			foundClasses.push(css);
			
			// Set the Haxe class to resolve to the css class if not already done.
			if (!haxeClasses.exists(css)) {
				haxeClasses.set(css, resolved);
			}
			// Set or add to the array of elements that have this class name.
			if (!classElements.exists(css)) {
				classElements.set(css, [element]);
			} else {
				classElements.get(css).push(element);
			}
			
		}
		
	}
	
	private static function matchId(css:String, element:Xml) {
		var resolved = null;
		
		if (Common.ignoreNames.indexOf(css) != -1) {
			return;
		}
		
		// Find the matching Haxe class. Will be `null` more often than not.
		resolved = Type.resolveClass( Common.userClasses.exists(css) ? Common.userClasses.get(css) : css );
		
		if (resolved != null) {
			
			css = Type.getClassName(resolved);
			
			foundIds.push(css);
			
			// Set the Haxe class to resolve to the css class if not already done.
			if (!haxeClasses.exists(css)) {
				haxeClasses.set(css, resolved);
			}
			// Set or add to the array of elements that have this class name.
			if (!idElements.exists(css)) {
				idElements.set(css, [element]);
			} else {
				idElements.get(css).push(element);
			}
			
		}
		
	}
	
	private static function matchField(css:String, element:Xml, isStatic:Bool = false) {
		if (Common.ignoreNames.indexOf(css) != -1) {
			return;
		}
		
		// Find the matching field from last matched class, backwards until found or non match.
		var classes = isStatic ? foundIds.copy() : foundClasses.copy();
		var cls:Class<Dynamic>;
		var fields:Array<String>;
		var path:String;
		var attribute:String = 'x-binding' + (isStatic ? '-static' : '');
		
		classes.reverse();
		
		for (c in classes) {
			
			cls = haxeClasses.get(c);
			fields = isStatic ? Type.getClassFields(cls) : Type.getInstanceFields(cls);
			
			if (fields.indexOf(css) != -1) {
				
				path = Type.getClassName(cls) + '.' + css;
				
				// Add a attribute to current element pointing to field
				if (element.attr(attribute) == '') {
					element.setAttr(attribute, path);
				} else {
					
					var bindings = element.attr(attribute).split(' ');
					if (bindings.indexOf(path) == -1) {
						bindings.push(Type.getClassName(cls) + '.' + css);
						element.setAttr(attribute, bindings.join(' '));
					}
					
				}
				
			}
			
		}
		
	}
	
	private static function processXML(x:Xml) {
		var names:Array<String>;
		
		if (x.attr('class') != '') {
			
			names = x.attr('class').split(' ');
			
			for (name in names) {
				
				// If the first letter is uppercase then its assumed to be
				// a possible Haxe class, otherwise a possible field.
				if ( name.charCodeAt(0).isUpperCaseAlphabetic() ) {
					matchClass(name, x);
				} else {
					matchField(name, x, false);
				}
				
			}
			
		}
		
		if (x.attr('id') != '') {
			
			names = x.attr('id').split(' ');
			
			if (names[0].charCodeAt(0).isUpperCaseAlphabetic()) {
				matchId(names[0], x);
			} else {
				matchField(names[0], x, true);
			}
			
		}
		
		for (c in x.children()) {
			processXML(c);
		}
		
	}
	
	// public fields

	public static function parse(html:String) {
		var xml:Xml = Html.toXml(html);
		var elements:Array<Xml>;
		
		for (x in xml) {
			processXML(x);
		}
		
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