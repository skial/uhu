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
	
	private static var isStatic:Bool = false;
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
		
		isStatic = true;
		
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
		var canSet:Bool = false;
		var canGet:Bool = false;
		
		var getter:ClassField = null;
		var setter:ClassField = null;
		
		// Find out if it variable can be set or read.
		// Get any getter or setter it might already have.
		// AccInline work around?
		switch(field.kind) {
			case FVar(read, write):
				
				switch(read) {
					case AccNormal:
						canGet = true;
					case AccCall(g):
						if (isStatic) {
							getter = currentTem.cls.statics.get().getClassField(g);
						} else {
							getter = currentTem.cls.fields.get().getClassField(g);
						}
						canGet = true;
					default:
						canGet = false;
				}
				
				switch (write) {
					case AccNormal:
						canSet = true;
					case AccCall(s):
						if (isStatic) {
							setter = currentTem.cls.statics.get().getClassField(s);
						} else {
							setter = currentTem.cls.fields.get().getClassField(s);
						}
						canSet = true;
					default:
						canSet = false;
				}
				
			default:
		}
		
		
	}
	
	private static function method(field:ClassField) {
		
	}
	
	private static function createGetter(field:ClassField) {
		
	}
	
	private static function createSetter(field:ClassField) {
		
	}
	
}