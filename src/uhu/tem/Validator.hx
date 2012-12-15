package uhu.tem;

import dtx.XMLWrapper;
import haxe.macro.Context;
import haxe.macro.Type;
import uhu.tem.Common;

using uhu.tem.Util;
using Detox;
using Lambda;
using StringTools;

/**
 * ...
 * @author Skial Bainn
 */

class Validator {
	
	private static var currentElement:Xml = null;
	//private static var currentTem:TemClass = null;

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
				
				//var tem:TemClass = Common.classes.get(pack.pop());
				//var mfield:ClassField = tem.cls.fields.get().getClassField(name);
				var mfield:ClassField = Common.currentClass.fields.get().getClassField(name);
				
				//currentTem = tem;
				
				fieldKind(mfield);
				
			}
			
		}
		
		if ( xml.exists(Common.x_static) ) {
			
			currentElement = xml;
			var field = xml.attr(Common.x_static).split(' ')[0];
			
			var pack:Array<String> = field.split('.');
			var name:String = pack.pop();
			
			//var tem:TemClass = Common.classes.get(pack.pop());
			//var mfield:ClassField = tem.cls.statics.get().getClassField(name);
			var mfield:ClassField = Common.currentClass.statics.get().getClassField(name);
			
			//currentTem = tem;
			
			fieldKind(mfield);
			
		}
		
		for (c in xml.children()) {
			processXML(c);
		}
	}
	
	private static function fieldKind(field:ClassField) {
		trace('kind');
		switch (field.kind) {
			case FVar(_, _):
				variable(field);
			case FMethod(_):
				method(field);
		}
		
	}
	
	private static function variable(field:ClassField) {
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
		
		if (!canGet && !canSet) {
			Context.error(Common.currentClass.name + '.' + field.name + ' can not be set or read.', Context.currentPos());
		}
		
		var first = currentElement.firstChild();
		var mtype = field.type;
		var stype = field.type.getFieldType();
		
		if (!stype.startsWith('Array')) {
			
			switch (stype) {
				case 'Dynamic':
					Context.warning(Common.currentClass.name + '.' + field.name + ' type of [Dynamic] will be treated as type [String].', Context.currentPos());
				case 'String':
					if ( first.isComment() || first.isElement() ) {
						Context.error(Common.currentClass.name + '.' + field.name + ' type of [String] has to be of type DOMNode to accept ' + first.toString(), Context.currentPos());
					}
				default:
			}
			
		} else {
			
			var sub = stype.split('::').pop();
			
			if (['String', 'DOMNode', 'Dynamic'].indexOf(sub) == -1) {
				if (sub == 'Dynamic') {
					Context.warning(Common.currentClass.name + '.' + field.name + ' type of [Dynamic] will be treated as type [String].', Context.currentPos());
				}
				Context.error(Common.currentClass.name + '.' + field.name + ' type of [Array<' + sub + '>] has to be of type DOMNode, String or Dynamic.', Context.currentPos());
			}
			
		}
		
	}
	
	private static function method(field:ClassField) {
		
		switch (field.kind) {
			case FMethod(kind):
				
				switch (kind) {
					case MethInline, MethMacro, MethDynamic:
						Context.error(Common.currentClass.name + '.' + field.name + ' will not be used to bind with the element ' + currentElement.toString() + ' because inline, dynamic or macro methods are not currently supported.', Context.currentPos());
					default:
				}
				
			default:
		}
		
	}
	
}