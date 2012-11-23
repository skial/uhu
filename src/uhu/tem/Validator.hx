package uhu.tem;

import dtx.XMLWrapper;
import haxe.macro.Context;
import uhu.tem.Common;
import haxe.macro.Type;

using uhu.tem.Util;
using Detox;
using Lambda;
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
		
		var instances = xml.runtimeSelect('[' + Common.x_instance + ']');
		var statics = xml.runtimeSelect('[' + Common.x_static + ']');
		
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
		
		return xml;
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
		var mtype = field.type;
		var stype = field.type.getFieldType();
		
		if (!stype.startsWith('Array')) {
			
			switch (stype) {
				case 'Dynamic':
					Context.warning(currentTem.name + '.' + field.name + ' type of [Dynamic] will be treated as type [String].', Context.currentPos());
				case 'String':
					if ( first.isComment() || first.isElement() ) {
						Context.error(currentTem.name + '.' + field.name + ' type of [String] has to be of type DOMNode to accept ' + first.toString(), Context.currentPos());
					}
				default:
			}
			
		} else {
			
			var sub = stype.split('::').pop();
			
			if (['String', 'DOMNode', 'Dynamic'].indexOf(sub) == -1) {
				if (sub == 'Dynamic') {
					Context.warning(currentTem.name + '.' + field.name + ' type of [Dynamic] will be treated as type [String].', Context.currentPos());
				}
				Context.error(currentTem.name + '.' + field.name + ' type of [Array<' + sub + '>] has to be of type DOMNode, String or Dynamic.', Context.currentPos());
			}
			
		}
		
	}
	
	private static function method(field:ClassField) {
		
		switch (field.kind) {
			case FMethod(kind):
				
				switch (kind) {
					case MethInline, MethMacro, MethDynamic:
						Context.error(currentTem.name + '.' + field.name + ' will not be used to bind with the element ' + currentElement.toString() + ' because inline, dynamic or macro methods are not currently supported.', Context.currentPos());
					default:
				}
				
			default:
		}
		
	}
	
}