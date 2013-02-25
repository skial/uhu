package uhu.tem.common;

import uhu.tem.i.ICommon;
import uhu.tem.t.TemClass;

import haxe.macro.Type;
import haxe.macro.Expr;

using Detox;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class Common_Macro implements ICommon {
	
	public var html:DOMNode;
	public var file:String;

	public var current:TemClass;
	public var binding:String;
	
	public var fields:Array<Field>;
	public var ignore:Array<String>;
	
	public function new() {
		current = {
			name:null,
			cls:null,
			params:null
		}
		
		binding = 'data-binding';
		
		fields = [];
		ignore = ['class', 'id', binding];
	}
	
}