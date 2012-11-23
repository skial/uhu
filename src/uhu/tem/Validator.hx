package uhu.tem;

import haxe.macro.Context;
import uhu.tem.Common;
import haxe.macro.Type;

using uhu.tem.Util;
using Detox;
using StringTools;
using selecthxml.SelectDom;
using tink.macro.tools.MacroTools;

/**
 * ...
 * @author Skial Bainn
 */

class Validator {
	
	private static var currentElement:Xml = null;
	private static var currentTem:TemClass = null;

	public static function parse(xml:Xml) {
		
		var instances = xml.runtimeSelect('[x-binding]');
		var statics = xml.runtimeSelect('[x-binding-static]');
		
		var fields:Array<String>;
		
		for (i in instances) {
			
			currentElement = i;
			fields = i.attr('x-binding').split(' ');
			
			for (field in fields) {
				
				var pack:Array<String> = field.split('.');
				var name:String = pack.pop();
				
				var tem:TemClass = Common.classes.get(pack.pop());
				var mfield:ClassField = tem.cls.fields.get().getClassField(name);
				
				currentTem = tem;
				
				instanceField(mfield);
				
			}
			
		}
		
		return xml;
	}
	
	private static function instanceField(field:ClassField) {
		
		switch (field.kind) {
			case FVar(_, _):
				instanceVariable(field);
			case FMethod(_):
				instanceMethod(field);
			default:
		}
		
	}
	
	private static function instanceVariable(field:ClassField) {
		var canSet:Bool = false;
		var canGet:Bool = false;
		
		// AccInline work around?
		switch(field.kind) {
			case FVar(read, write):
				
				switch(read) {
					case AccNo, AccNever, AccInline, AccResolve, AccRequire(_):
						canGet = false;
					default:
						canGet = true;
				}
				
				switch (write) {
					case AccNo, AccNever, AccInline, AccResolve, AccRequire(_):
						canSet = false;
					default:
						canSet = true;
				}
				
			default:
		}
		
		var first = currentElement.firstChild();
		
		
		
		trace(currentElement.firstChild());
		trace(field.type.getID());
		
	}
	
	private static function instanceMethod(field:ClassField) {
		
	}
	
}