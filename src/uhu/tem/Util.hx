package uhu.tem;

import haxe.io.StringInput;
import selecthxml.engine.Lexer;
import selecthxml.SelectDom;
import haxe.macro.Type;

using Lambda;
using tink.macro.tools.MacroTools;

/**
 * ...
 * @author Skial Bainn
 */

class Util {
	
	private static var last_field:ClassField = null;
	
	public static function hasClassField(fields:Array<ClassField>, name:String):Bool {
		return fields.exists( function(f) {
			if (f.name == name) {
				last_field = f;
				return true;
			}
			return false;
		} );
	}
	
	public static function getClassField(fields:Array<ClassField>, name:String):Null<ClassField> {
		if (last_field != null && last_field.name == name) return last_field;
		
		if ( Util.hasClassField(fields, name) ) {
			return last_field;
		}
		
		return null;
	}

	/*public static function select(element:Xml, selectorString:String) {
		var lexer = new Lexer(new StringInput(selectorString));
		var parser = new selecthxml.engine.Parser(lexer);
		var selector = parser.parse();
		
		var selectorExprs = [];
		
		//for (s in selector) selectorExprs.push(s.toExpr());
		var ret:Dynamic = Util.applySelector(element, selector);
		
		if (isSingular(selector)) {
			ret = ret.shift();
		}
		
		var ret = switch(selecthxml.engine.TypeResolver.resolve(element, selector))
		{
			case Option.None:
				ret;
			case Option.Some(f):
				if (isSingular(selector))
					EFunction(null, f.instantiate([ret]).func([], TPath(f))).at(element.pos).call([]);
				else
				{
					var funcExpr = [
						"xmls".define(ret),
						"ret".define([].toExpr()),
						"xmls".resolve().iterate(
							"ret".resolve().field("push").call([f.instantiate(["element".resolve()])])
						, "xml"),
						"ret".resolve()
					].toBlock();
					EFunction(null, funcExpr.func([], "Array".asComplexType([TPType(TPath(f))]))).at(element.pos).call([]);
				}
		}
		
		return ret;
	}
	
	public static function applySelector(xml:Xml, selector:selecthxml.engine.Type.Selector) {
		if (isIdOnly(selector)) {
			return [ selecthxml.engine.XmlExtension.getElementById(xml, selector[0].id) ];
		}
		
		var engine = new selecthxml.engine.SelectEngine();
		var result = engine.query(selector, xml);
		return result;
	}
	
	static inline function isSingular(s:selecthxml.engine.Type.Selector):Bool {
		return s[s.length - 1].id != null;
	}
	
	public static function isIdOnly(s:selecthxml.engine.Type.Selector):Bool {
		var p = s[0];		
		return s.length == 1 
			&& p.id != null 
			&& p.tag == null 
			&& p.classes.length == 0
			&& p.attrs.length == 0
			&& p.pseudos.length == 0
			&& p.combinator == null;
	}*/
	
}