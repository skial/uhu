package uhu.tem;

import Xml;
import dtx.XMLWrapper;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Compiler;
import haxe.macro.Context;
import sys.io.File;
import uhu.macro.Du;
import haxe.xml.Parser;
import thx.html.Html;
import uhu.tem.Common;

using Detox;
using Lambda;
using StringTools;
using uhu.Library;
using uhu.tem.Util;
using de.polygonal.core.fmt.ASCII;

/**
 * ...
 * @author Skial Bainn
 */

class Scope {
	
	private static var classElements:Hash<Array<Xml>> = new Hash<Array<Xml>>();
	private static var foundClasses:Array<String> = new Array<String>();
	
	private static var idElements:Hash<Array<Xml>> = new Hash<Array<Xml>>();
	private static var foundIds:Array<String> = new Array<String>();
	
	private static var haxeClasses:Hash<ClassType> = new Hash<ClassType>();
	
	private static function matchCSS(css:String, element:Xml, id:Bool) {
		var resolved = null;
		var found = id ? foundIds : foundClasses;
		var elements = id ? idElements : classElements;
		
		if ( Common.ignoreClass.indexOf(css) != -1 ) {
			return;
		}
		
		// Find the matching Haxe class. Will be `null` more often than not.
		//resolved = Common.classes.get(css);
		resolved = Common.currentClass;
		
		if (resolved != null) {
			
			css = resolved.name;
			
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
		
		// Find the matching field from last matched class, backwards until found or none match.
		//var classes = isStatic ? foundIds.copy() : foundClasses.copy();
		//var classes = findParents(element, isStatic ? 'id' : 'class' );
		var tem:ClassType;
		var fields:Array<Field>;
		var path:String;
		var attribute:String = isStatic ? Common.x_static : Common.x_instance;
		var field:Field;
		var values:Array<String>;
		
		//classes.reverse();
		
		//for (c in classes) {
			
			//if (!haxeClasses.exists(c)) continue;
			
			//tem = haxeClasses.get(c);
			tem = Common.currentClass;
			
			//fields = isStatic ? tem.statics.get() : tem.fields.get();
			fields = isStatic ? Common.currentStatics : Common.currentFields;
			
			field = fields.getClassField(css);
			
			//if (field == null) continue;
			if (field == null) return;
			
			// Added x-binding[-static] with full path to field.
			// Allows easy access for other parts of Tem
			element.addBinding(tem.name + '.' + field.name, isStatic);
			
		//}
		
	}
	
	private static function findParents(element:Xml, type:String) {
		// TODO Change type to enum??
		var result:Array<String> = [];
		var attribute:String;
		
		// TODO Not sure if pulling all possibly valid class names on current element is needed. Problem point.
		if ( type == 'class' && element.attr(type) != '' ) {
			
			attribute = element.attr(type);
			
			for (attr in attribute.split(' ')) {
				
				if ( attr.charCodeAt(0).isUpperCaseAlphabetic() && Common.classes.exists(attr) ) {
					result.push( Common.classes.get(attr).name );
				}
				
			}
			
		}
		
		for (p in element.ancestors()) {
			
			if (p.attr(type) != '') {
				attribute = p.attr(type);
				if ( type == 'id' ) {
					
					attribute = attribute.split(' ')[0];
					
					if ( attribute.split(' ')[0].charCodeAt(0).isUpperCaseAlphabetic() && Common.classes.exists(attribute.split(' ')[0]) ) {
						result.push( Common.classes.get(attribute.split(' ')[0]).name );
					}
					
				} else if ( type == 'class' ) {
					
					for (attr in attribute.split(' ')) {
						
						if ( attr.charCodeAt(0).isUpperCaseAlphabetic() && Common.classes.exists(attr) ) {
							result.push( Common.classes.get(attr).name );
						}
						
					}
					
				}
			}
			
		}
		
		return result;
	}
	
	private static function isValidClass(name:String):Bool {
		name = name.trim();
		var r = ( name == Common.currentClass.name && name.charCodeAt(0).isUpperCaseAlphabetic() && Common.ignoreClass.indexOf(name) == -1 );
		/*trace(name);
		trace(Common.currentClass.name == name);
		trace(name.charCodeAt(0).isUpperCaseAlphabetic());
		trace(Common.ignoreClass.indexOf(name) == -1);
		trace(r);*/
		return r;
	}
	
	private static function processXML(x:Xml) {
		var names:Array<String>;
		var matched:Bool = false;
		
		if (x.attr('class') != '') {
			
			names = x.attr('class').split(' ');
			
			for (name in names) {
				
				// css selector name must match current Class being processed.
				//if ( name != Common.currentClass.name ) continue;
				if ( !isValidClass(name) ) continue;
				
				// If the first letter is uppercase then its assumed to be
				// a possible Haxe class, otherwise a possible field.
				if ( name.charCodeAt(0).isUpperCaseAlphabetic() ) {
					
					matched = true;
					matchCSS(name, x, false);
					
				}
				
			}
			
		}
		
		if (x.attr('id') != '') {
			
			names = x.attr('id').split(' ');
			
			// If the first letter is uppercase then its assumed to be
				// a possible Haxe class, otherwise a possible field.
			if ( names[0].charCodeAt(0).isUpperCaseAlphabetic() ) {
				
				matched = true;
				matchCSS(names[0], x, true);
				
			}
			
		}
		
		var attr:String;
		
		// Some html makes Haxe's xml parser cry
		try {
			if (matched) {
				for (a in x.attributes()) {
					
					if (Common.ignoreField.indexOf(a) == -1) {
						
						attr = a.trim();
						if (attr.startsWith('data-')) {
							attr = attr.substr(5);
						}
						
						// First check static classes
						matchField(attr, x, true);
						// Then check instances
						matchField(attr, x, false);
						
					}
					
				}
			}
		} catch (e:Dynamic) {}
		
		for (c in x.children()) {
			processXML(c);
		}
		
	}

	public static function parse(xml:Xml) {
		
		for (x in xml) {
			processXML(x);
		}
		
		return xml;
	}
	
}