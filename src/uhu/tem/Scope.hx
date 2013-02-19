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
	
	/*public static function isValidClass(name:String):Bool {
		name = name.trim();
		var r = ( name == Common.currentClass.name && name.charCodeAt(0).isUpperCaseAlphabetic() && Common.ignoreClass.indexOf(name) == -1 );
		return r;
	}*/
	
	public function new() { 
		
	}
	
	public function parse(xml:Xml) {
		
		for (x in xml) {
			processXML( x );
		}
		
		return xml;
	}
	
	public function processXML(xml:Xml) {
		
		if (findIds( xml ).indexOf( Common.currentClass.name ) != -1) {
			matchAttributes(xml, true);
		}
		
		if (findClasses( xml ).indexOf( Common.currentClass.name ) != -1) {
			matchAttributes(xml, false);
		}
		
		for (child in xml.children()) {
			processXML( child );
		}
		
	}
	
	public function findIds(xml:Xml):Array<String> {
		var results = [xml.attr('id').split(' ')[0].trim()];
		
		for (ancestor in xml.ancestors()) {
			
			if (ancestor.attr('id') != '') {
				results.push( ancestor.attr('id').split(' ')[0].trim() );
			}
			
		}
		
		return results;
	}
	
	public function findClasses(xml:Xml):Array<String> {
		var attr:String = xml.attr('class');
		var results:Array<String> = attr.indexOf(' ') != -1 ? attr.split(' ') : [attr];
		
		for (ancestor in xml.ancestors()) {
			
			if (ancestor.attr('class') != '') {
				results = results.concat( ancestor.attr('class').split(' ') );
			}
			
		}
		
		return results;
	}
	
	public function matchAttributes(xml:Xml, isStatic:Bool) {
		var attr:String;
		var fields = isStatic ? Common.currentStatics : Common.currentFields;
		
		if (fields.length == 0) return;
		
		for (attribute in xml.attributes()) {
			
			attr = attribute;
			
			if (Common.ignoreField.indexOf( attr ) != -1) continue;
			
			if (attr.startsWith('data-')) attr = attr.substr(5).trim();
			
			if (fields.getClassField( attr ) != null) matchField(attr, xml, isStatic);
			
		}
	}
	
	public function matchField(css:String, element:Xml, isStatic:Bool = false):Bool {
		var fields = isStatic ? Common.currentStatics : Common.currentFields;
		var field = fields.getClassField(css);
		var result = false;
		
		if (field != null) {
			
			element.addBinding('${Common.currentClass.name}.${field.name}', isStatic);
			result = true;
			
		}
		
		return result;
	}
	
}