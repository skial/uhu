package uhu.tem;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

import uhu.tem.Common;
import uhu.tem.t.TemClass;

using uhu.tem.Util;
using Detox;

/**
 * ...
 * @author Skial Bainn
 */

class Binder {
	
	public static function parse(xml:Xml) {
		
		for (x in xml) {
			
			try {
				processXML( x );
			} catch (e:Dynamic) {
				trace(e);
			}
			
		}
		
	}
	
	public static function processXML(xml:Xml) {
		
	}
	
}
