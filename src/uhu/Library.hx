package uhu;

#if (macro || neko)
import haxe.macro.Expr;
import haxe.macro.Context;
import tink.macro.tools.AST;

using tink.macro.tools.MacroTools;
#end 

#if js
import js.Lib;
import js.Dom;
import uhu.js.typedefs.TBoundingClientRect;
import uhu.js.typedefs.TDocument;
import uhu.js.typedefs.TWindow;
#end

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

class Library {
	
	#if js
	public static var window:TWindow = untyped __js__('window');
	public static var document:TDocument = untyped __js__('document');
	
	public static inline function getBoundingClientRect(element:HtmlDom):TBoundingClientRect {
		return untyped element.getBoundingClientRect();
	}
	
	public static function getComputedStyle(element:HtmlDom):Style untyped {
		var style:Style = null;
		
		if (__js__('window').getComputedStyle != null) {
			style = __js__('window').getComputedStyle(element, null);
		} else {
			style = cast element.currentStyle;
		}
		
		return style;
	}
	
	/**
	 * Got this from [domtools (dtx, detox)?](https://github.com/jasononeil/domtools) 
	 * Thanks!
	 */
	public static function parse(html:String):HtmlDom {
		var e = Lib.document.createElement('div');
		e.innerHTML = html;
		return e.firstChild;
	}
	
	/**
	 * Not cool
	 */
	public static inline function addEventListener(element:HtmlDom, type:String, listener:Dynamic, ?useCapture:Bool):Void {
		untyped element.addEventListener(type, listener, useCapture);
	}
	
	public static inline function removeEventListener(element:HtmlDom, type:String, listener:Dynamic, ?useCapture:Bool):Void {
		untyped element.removeEventListener(type, listener, useCapture);
	}
	#end
	
	/**
	 * From domtools(dtx|detox)? Widget class - thanks!
	 */
	@:macro 
	public static function loadTemplate( fileName : ExprOf<String> )	{
		var p = Context.currentPos();
		var f:String;
		
		/*
		 * Get the name of the file passed to the macro
		 */
		var templateFile = switch( fileName.expr ) {
			case EConst(c):
				
				switch( c ) {
					case CString(str):
						str;
					default: 
						null;
				}
				
			default: 
				null;
		} 
		
		try {
			/*
			 * Try to read the specified file
			 */
			f = neko.io.File.getContent(Context.resolvePath(templateFile));
		} catch( e : Dynamic ) {
			/*
			 * If it fails, give an error message at compile time
			 */
			var errorMessage = "Could not load template: " + templateFile;
			Context.error(errorMessage, p);
		}
		
		return { expr : EConst(CString(f)), pos : p };
	}
	
	#if js
	@:macro
	public static function untype(e:ExprOf<Dynamic>):Expr {
		/**
		 * Returns the expression but untyped.
		 */
		return Context.parse(Std.format('untyped __js__("${e.toString()}")'), Context.currentPos());
	}
	#end
	
	/**
	 * https://developers.google.com/closure/compiler/docs/api-tutorial3#propnames
	 */
	@:macro
	public static function exportProperty(e:ExprOf<Dynamic>):Expr {
		#if !display
		var output:String = null;
		
		switch(e.expr) {
			case EObjectDecl(_fields):
				/**
				 * If _fields length is 0 return original expr
				 */
				if (_fields.length == 0) return e;
				
				/**
				 * Loop over each expr in _fields and construct the same
				 * anonymous object, but with keys quoted.
				 */
				for (_f in _fields) {
					
					if (_f == _fields[0]) {
						output = Std.format('untyped __js__(\'{ "${_f.field}":${_f.expr.toString()}');
					} else {
						output += Std.format(', "${_f.field}":${_f.expr.toString()}');
					}
					
				}
				
				/**
				 * Close the expr.
				 */
				output += ' }\')';
				
				/**
				 * Parse newly constructed string into an expr, replacing
				 * the old expr.
				 */
				return Context.parse(output, e.pos);
			case EField(_expr, _field):
				/**
				 * Convert expr into a string. Then split it by
				 * dot access
				 */
				var parts:Array<String> = e.toString().split('.');
				
				/**
				 * If parts is empty, return original expr
				 */
				if (parts.length == 0) return e;
				
				/**
				 * Loop over each part. Instead of dot access,
				 * it gets converted into array access. This is
				 * Google Closure Compiler safe. Prevents variable renaming.
				 */
				for (p in parts) {
					
					if (p == parts[0]) {
						output = Std.format('untyped $p');
					} else {
						output += Std.format('["$p"]');
					}
					
				}
				
				/**
				 * Parse newly constructed string into an expr, replacing
				 * the old expr.
				 */
				return Context.parse(output, e.pos);
			case ECall(_expr, _params):
				/**
				 * Convert expr into basic parts. Name, package and field.
				 */
				var basic:TypePath = getTypePath(_expr.toString().asComplexType());
				var params:Array<String> = new Array<String>();
				
				/**
				 * Convert all, if any, parameters to strings.
				 */
				if (_params.length != 0) {
					
					for (_p in _params) {
						params.push(_p.toString());
					}
					
				}
				
				/**
				 * Start constructing the new expr.
				 */
				output = Std.format('untyped ${basic.name}["${basic.sub}"]');
				
				for (p in params) {
					if (p == params[0]) {
						output += Std.format('($p');
						continue;
					}
					output += Std.format(', $p');
				}
				
				output += ')';
				
				/**
				 * Parse newly constructed string into an expr, replacing
				 * the old expr.
				 */
				return Context.parse(output, Context.currentPos());
			default:
				trace('uhu.Library.exportProperties : unknown');
				trace(e.toString());
				return e;
		}
		#else
		return e;
		#end
	}
	
	#if (macro || neko)
	private static function getTypePath(from:ComplexType):TypePath {
		switch(from) {
			case TPath(_p):
				return _p;
			default:
				return { pack : ['unknown'], name : 'unknown', params : [], };
		}
	}
	#end
	
}