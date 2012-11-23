package uhu.tem;

import uhu.tem.Common;
import haxe.macro.Type;

using uhu.tem.Util;
using Detox;
using StringTools;
using selecthxml.SelectDom;

/**
 * ...
 * @author Skial Bainn
 */

class Validator {
	
	private static var current:Xml = null;

	public static function parse(xml:Xml) {
		
		var instances = xml.runtimeSelect('[x-binding]');
		var statics = xml.runtimeSelect('[x-binding-static]');
		
		var fields:Array<String>;
		
		for (i in instances) {
			
			current = i;
			fields = i.attr('x-binding').split(' ');
			
			for (field in fields) {
				
				var pack:Array<String> = field.split('.');
				var name:String = pack.pop();
				
				var tem:TemClass = Common.classes.get(pack.pop());
				var mfield:ClassField = tem.cls.fields.get().getClassField(name);
				
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
		
	}
	
	private static function instanceMethod(field:ClassField) {
		
	}
	
}