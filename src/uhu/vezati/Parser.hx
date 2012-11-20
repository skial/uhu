package uhu.vezati;

import haxe.macro.Context;
import uhu.macro.Du;
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

class Parser {
	
	// private fields
	
	private static var userClasses:Hash<String> = new Hash<String>();
	
	private static var classElements:Hash<Array<Xml>> = new Hash<Array<Xml>>();
	private static var haxeClasses:Hash<Class<Dynamic>> = new Hash<Class<Dynamic>>();
	private static var foundClasses:Array<String> = new Array<String>();
	
	private static var idElements:Hash<Array<Xml>> = new Hash<Array<Xml>>();
	
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
				resolved = Type.resolveClass( userClasses.exists(n) ? userClasses.get(n) : n );
				
				if (resolved != null && n.charCodeAt(0).isUpperCaseAlphabetic()) {
					
					n = Type.getClassName(resolved);
					
					foundClasses.push(n);
					
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
					
					for (c in foundClasses) {
						
						for ( field in Type.getInstanceFields( haxeClasses.get(c) ) ) {
							
							
							
						}
						
					}
					
				}
				
			}
			
		}
		
	}
	
	private static function checkCssIds(ids:Array<Xml>) {
		
	}
	
	// public fields

	public static function parse(html:String, ?classes:Array<String>) {
		if (classes != null) {
			for (c in classes) {
				userClasses.set(c.split('.').pop(), c);
			}
		}
		
		var xml:Xml = Html.toXml(html);
		var elements:Array<Xml>;
		
		// handle `class="..."`
		elements = xml.runtimeSelect('[class]');
		checkCssClasses( elements );
		// handle `class="..."`
		elements = xml.runtimeSelect('[id]');
		checkCssIds( elements );
		
		return { };
	}
	
}

class Class1 {
	public function new() { }
	public function format() {}
}

class MyClass {
	public function new() { }
	public function format() {}
}