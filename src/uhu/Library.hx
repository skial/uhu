package uhu;

#if macro
typedef WindowProxy = Dynamic;
typedef HTMLElement = Dynamic;
typedef CSSStyleDeclaration = Dynamic;

import haxe.macro.Compiler;
import haxe.macro.Expr;
import haxe.macro.Context;
import tink.macro.tools.AST;
import uhu.macro.Du;

import uhu.js.typedefs.TBoundingClientRect;

using tink.macro.tools.MacroTools;
#end 

#if js
import UserAgent;
import UserAgentContext;
#end

using Std;
using StringTools;

import uhu.js.typedefs.TBoundingClientRect;

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

class Library {
	
	@:macro public static function requestAnimationFrame(window:ExprOf<WindowProxy>, handler:ExprOf<Dynamic>, ?element:ExprOf<HTMLElement>):ExprOf<Dynamic> {
		Compiler.define('raf');
		Du.include(['uhu.js.RAF']);
		return macro untyped __js__('window.requestAnimationFrame')($handler, $element);
	}
	
	@:macro public static function cancelAnimationFrame(window:ExprOf<WindowProxy>, id:ExprOf<Int>):ExprOf<Void> {
		Compiler.define('raf');
		Du.include(['uhu.js.RAF']);
		return macro untyped __js__('window.cancelAnimationFrame')($id);
	}
	
	
	@:extern public static inline function getBoundingClientRect(element:HTMLElement):TBoundingClientRect {
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
		
		return Context.makeExpr(f, p);
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
	@:macro public static function exportProperty(e:ExprOf<Dynamic>) {
		var output = '';
		
		switch (e.expr) {
			case EObjectDecl(_fields):
				
				if (_fields.length == 0) return e;
				
				output += 'untyped __js__(\'{';
				
				for (_field in _fields) {
					
					if (_field == _fields[0]) {
						output += ' "${_field.field}":${_field.expr.toString()}'.format();
					} else {
						output +=', "${_field.field}":${_field.expr.toString()}'.format();
					}
					
				}
				
				output += '}\')';
				
				return Context.parse(output, e.pos);
				
			case EField(_expr, _field):
				
				output += 'untyped __js__(\'${_expr.toString()}["$_field"]\')'.format();
				
				return Context.parse(output, e.pos);
				
			case ECall(_expr, _params):
				
				var expr = _expr.toString();
				var parts = expr.split('.');
				var last = parts.pop();
				var params = '';
				
				for (param in _params) {
					params += param.toString() != 'null' ? param.toString() : '';
					if (param != _params[_params.length -1]) params += ', ';
				}
				
				if (params.endsWith(', ')) params = params.substr(0, params.length - 2);
				
				output = parts.join('.') + '["' + last + '"]';
				output += '(' + params + ')';
				
				return Context.parse('untyped __js__(\'' + output + '\')', e.pos);
				
			default:
				trace('default');
				trace(e);
		}
		
		return e;
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