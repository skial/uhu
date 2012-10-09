package uhu;

#if macro
typedef WindowProxy = Dynamic;
typedef HTMLElement = Dynamic;
typedef CSSStyleDeclaration = Dynamic;

import haxe.macro.Compiler;
import haxe.macro.Expr;
import haxe.macro.Context;
import tink.macro.tools.AST;

import uhu.js.typedefs.TBoundingClientRect;

using tink.macro.tools.MacroTools;
#end 

#if js
//import js.Lib;
import UserAgent;
import UserAgentContext;
#end

using Std;

import uhu.js.typedefs.TBoundingClientRect;

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

class Library {
	
	@:macro public static function requestAnimationFrame(window:ExprOf<WindowProxy>, handler:ExprOf<Dynamic>, ?element:ExprOf<HTMLElement>):ExprOf<Dynamic> {
		Compiler.define('raf');
		Context.getModule('uhu.js.RAF');
		return macro untyped __js__('window.requestAnimationFrame')($handler, $element);
	}
	
	@:macro public static function cancelAnimationFrame(window:ExprOf<WindowProxy>, id:ExprOf<Int>):ExprOf<Void> {
		Compiler.define('raf');
		Context.getModule('uhu.js.RAF');
		return macro untyped __js__('window.cancelAnimationFrame')($id);
	}
	
	
	public static inline function getBoundingClientRect(element:HTMLElement):TBoundingClientRect {
		return untyped element.getBoundingClientRect();
	}
	
	public static function getComputedStyle(element:HTMLElement):CSSStyleDeclaration untyped {
		var style:CSSStyleDeclaration = null;
		
		if (__js__('window').getComputedStyle != null) {
			style = __js__('window').getComputedStyle(element, null);
		} else {
			style = cast element.currentStyle;
		}
		
		return style;
	}
	
	/**
	 * Not cool
	 */
	@:extern public static inline function addEventListener(element:HTMLElement, type:String, listener:Dynamic, ?useCapture:Bool):Void {
		untyped element.addEventListener(type, listener, useCapture);
	}
	
	@:extern public static inline function removeEventListener(element:HTMLElement, type:String, listener:Dynamic, ?useCapture:Bool):Void {
		untyped element.removeEventListener(type, listener, useCapture);
	}
	
	/**
	 * From domtools(dtx|detox)? Widget class - thanks!
	 */
	@:macro public static function loadTemplate(fileName:ExprOf<String>):ExprOf<String>	{
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
		
		return macro f;
	}
	
	@:macro public static function untype(e:ExprOf<Dynamic>):ExprOf<Dynamic> {
		/**
		 * Returns the expression but untyped.
		 */
		return Context.parse(Std.format('untyped __js__("${e.toString()}")'), Context.currentPos());
	}
	
	/**
	 * https://developers.google.com/closure/compiler/docs/api-tutorial3#propnames
	 */
	@:macro public static function exportProperty(e:ExprOf<Dynamic>):Expr {
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
	
	#if macro
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