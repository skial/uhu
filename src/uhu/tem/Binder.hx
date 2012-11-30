package uhu.tem;

import haxe.macro.Context;
import uhu.tem.Common;
import haxe.macro.Expr;
import haxe.macro.Type;
//import tink.reactive.bindings.BindingTools;

using uhu.tem.Util;
using Detox;
//using selecthxml.SelectDom;
//using tink.macro.tools.MacroTools;

/**
 * ...
 * @author Skial Bainn
 */

class Binder {
	
	public static function build():Array<Field> {
		
		return Context.getBuildFields();
	}
	
	private static var isStatic:Bool = false;
	private static var currentElement:Xml = null;
	private static var currentTem:TemClass = null;
	
	public static function parse(xml:Xml) {
		
		for (x in xml) {
			try {
				processXML(x);
			} catch (e:Dynamic) { }
		}
		
		
		return xml;
	}
	
	private static function processXML(xml:Xml) {
		var fields:Array<String>;
		
		if ( xml.exists(Common.x_instance) ) {
			
			currentElement = xml;
			fields = xml.attr(Common.x_instance).split(' ');
			
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
		
		if ( xml.exists(Common.x_static) ) {
			
			currentElement = xml;
			var field = xml.attr(Common.x_static).split(' ')[0];
			
			var pack:Array<String> = field.split('.');
			var name:String = pack.pop();
			
			var tem:TemClass = Common.classes.get(pack.pop());
			var mfield:ClassField = tem.cls.statics.get().getClassField(name);
			
			currentTem = tem;
			
			fieldKind(mfield);
			
		}
		
		for (c in xml.children()) {
			processXML(c);
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
		
		trace(currentTem.cls.meta.get());
		
		modifyConstructor('');
	}
	
	private static function method(field:ClassField) {
		
	}
	
	private static function modifyConstructor(selector:String) {
		var expr = Context.getTypedExpr( currentTem.cls.constructor.get().expr() );
		trace(currentTem.name);
		switch (expr.expr) {
			case EFunction(name, method):
				method.args.push( { name:'temID', opt:true, type:Context.toComplexType(Context.getType('String')) } );
			default:
		}
	}
	
	private static function createGetter(field:ClassField, hasGetter:Bool = false) {
		
	}
	
	private static function createSetter(field:ClassField, hasSetter:Bool = false) {
		
	}
	
}
