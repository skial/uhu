package uhu.tem;

import uhu.tem.Common;
import haxe.macro.Type;
import tink.reactive.bindings.BindingTools;

using uhu.tem.Util;
using Detox;
using selecthxml.SelectDom;

/**
 * ...
 * @author Skial Bainn
 */

class Binder {
	
	private static var currentElement:Xml = null;
	private static var currentTem:TemClass = null;
	
	public static function parse(html:Xml) {
		
		var instances = html.runtimeSelect('[' + Common.x_instance + ']');
		var statics = html.runtimeSelect('[' + Common.x_static + ']');
		
		var fields:Array<String>;
		
		for (i in instances) {
			
			currentElement = i;
			fields = i.attr(Common.x_instance).split(' ');
			
			for (field in fields) {
				
				var pack:Array<String> = field.split('.');
				var name:String = pack.pop();
				
				var tem:TemClass = Common.classes.get(pack.pop());
				var mfield:ClassField = tem.cls.fields.get().getClassField(name);
				
				currentTem = tem;
				
				fieldKind(mfield);
				
			}
			
		}
		
		for (s in statics) {
			
			currentElement = s;
			var field = s.attr(Common.x_static).split(' ')[0];
			
			var pack:Array<String> = field.split('.');
			var name:String = pack.pop();
			
			var tem:TemClass = Common.classes.get(pack.pop());
			var mfield:ClassField = tem.cls.statics.get().getClassField(name);
			
			currentTem = tem;
			
			fieldKind(mfield);
			
		}
		
	}
	
	private static function fieldKind(field:ClassField) {
		
		switch (field.kind) {
			case FVar(_, _):
				variable(field);
			case FMethod(_):
				method(field);
			default:
		}
		
	}
	
	private static function variable(field:ClassField) {
		
	}
	
	private static function method(field:ClassField) {
		
	}
	
}