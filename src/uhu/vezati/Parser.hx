package uhu.vezati;

import Xml;
import haxe.xml.Parser;
import thx.html.Html;

using de.polygonal.core.fmt.ASCII;
using Lambda;
using Detox;
using uhu.Library;
using selecthxml.SelectDom;

/**
 * ...
 * @author Skial Bainn
 */

typedef TField = {
	// name is the full path to field eg my.package.MyClass.myField
	var name:String;
	var isStatic:Bool;
	var element:Xml;
}

class Parser {
	
	// private fields
	
	private static var classElements:Hash<Array<Xml>> = new Hash<Array<Xml>>();
	private static var haxeClasses:Hash<Class<Dynamic>> = new Hash<Class<Dynamic>>();
	
	private static var idElements:Hash<Array<Xml>> = new Hash<Array<Xml>>();
	
	// Used by both non/static class fields
	private static var haxeFields:Hash<TField> = new Hash<TField>();
	
	private static var ignore:Array<String> = ['Class'];
	
	private static function checkCssClasses(classes:Array<Xml>) {
		var names:Array<String>;
		var resolved = null;
		
		for (_class in classes) {
			
			names = _class.get('class').split(' ');
			
			for (n in names) {
				
				if (ignore.indexOf(n) != -1) {
					continue;
				}
				
				// Find the matching Haxe class. Will be `null` more often than not.
				resolved = Type.resolveClass(n);
				
				if (resolved != null && n.charCodeAt(0).isUpperCaseAlphabetic()) {
					
					// Set the Haxe class to resolve to the css class if not already done.
					if (!haxeClasses.exists(n)) {
						haxeClasses.set(n, resolved);
					}
					// Set or add to the array of elements that have this class name.
					if (!classElements.exists(n)) {
						classElements.set(n, [_class]);
					} else {
						classElements.get(n).push(_class);
					}
					
				} else {
					
					// TODO match css name to class instance fields.
					
				}
				
			}
			
		}
		
	}
	
	private static function checkCssIds(ids:Array<Xml>) {
		
	}
	
	// public fields

	public static function parse(html:String) {
		var xml:Xml = Html.toXml(html);
		var elements:Array<Xml>;
		
		// handle `class="..."`
		elements = xml.runtimeSelect('[class]');
		checkCssClasses( elements );
		// handle `class="..."`
		elements = xml.runtimeSelect('[id]');
		checkCssIds( elements );
		
		for (k in haxeClasses.keys()) {
			trace(haxeClasses.get(k));
		}
		
		return { };
	}
	
}