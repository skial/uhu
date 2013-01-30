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
//using uhu.Library;
using uhu.tem.Util;
using de.polygonal.core.fmt.ASCII;

/**
 * ...
 * @author Skial Bainn
 */

class Scope {
	
	public static function matchField(css:String, element:Xml, isStatic:Bool = false):Bool {
		//if (Common.ignoreClass.indexOf(css) != -1) return;
		
		var fields = isStatic ? Common.currentStatics : Common.currentFields;
		var field = fields.getClassField(css);
		
		if (field != null) {
			/*trace(Common.currentClass.name);
			trace(field.name);*/
			element.addBinding(Common.currentClass.name + '.' + field.name, isStatic);
			return true;
		}
		return false;
	}
	
	public static function findIds(x:Xml):Array<String> {
		var results = [x.attr('id').split(' ')[0].trim()];
		
		for (a in x.ancestors()) {
			
			if (a.attr('id') != '') {
				results.push(a.attr('id').split(' ')[0].trim());
			}
			
		}
		
		return results;
	}
	
	public static function findClasses(x:Xml):Array<String> {
		var attr:String = x.attr('class');
		var results:Array<String> = attr.indexOf(' ') != -1 ? attr.split(' ') : [attr];
		
		for (a in x.ancestors()) {
			
			if (a.attr('class') != '') {
				results = results.concat(a.attr('class').split(' '));
			}
			
		}
		
		return results;
	}
	
	public static function isValidClass(name:String):Bool {
		name = name.trim();
		var r = ( name == Common.currentClass.name && name.charCodeAt(0).isUpperCaseAlphabetic() && Common.ignoreClass.indexOf(name) == -1 );
		return r;
	}
	
	public static function processXML(x:Xml) {
		
		if (findIds(x).indexOf(Common.currentClass.name) != -1) {
			matchAttributes(x, true);
		}
		
		if (findClasses(x).indexOf(Common.currentClass.name) != -1) {
			matchAttributes(x, false);
		}
		
		for (c in x.children()) {
			processXML(c);
		}
		
	}
	
	public static function matchAttributes(x:Xml, isStatic:Bool) {
		// Some html makes Haxe's xml parser cry
		//try {
			
			var attr:String;
			var fields = isStatic ? Common.currentStatics : Common.currentFields;
			
			if (fields.length == 0) return;
			
			for (a in x.attributes()) {
				
				attr = a;
				
				if (Common.ignoreField.indexOf(attr) != -1) continue;
				
				if (attr.startsWith('data-')) attr = attr.substr(5).trim();
				
				if (fields.getClassField(attr) != null) matchField(attr, x, isStatic);
				
			}
			
		//} catch (e:Dynamic) {}
	}

	public static function parse(xml:Xml) {
		
		for (x in xml) {
			processXML(x);
		}
		
		return xml;
	}
	
}