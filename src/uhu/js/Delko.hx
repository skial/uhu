package uhu.js;

import haxe.macro.Tools;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.JSGenApi;
import haxe.macro.Compiler;
import haxe.macro.ExampleJSGenerator;
import sys.FileSystem;
import uhu.macro.Jumla;

import massive.neko.io.FileSys;
import massive.neko.util.PathUtil;

import sys.io.File;
import sys.io.FileOutput;

/*import tink.macro.tools.ExprTools;
import tink.macro.tools.MacroTools;
import tink.macro.tools.Printer;
import tink.macro.tools.TypeTools;
import tink.core.types.Outcome;
import tink.core.types.Option;*/

using uhu.macro.Jumla;
using Lambda;
using StringTools;
/*using tink.macro.tools.MacroTools;
using tink.core.types.Outcome;
using tink.core.types.Option;*/

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

class Delko  {
	
	public static var characters = {
		dot:".",
		carriage:"\r",
		newline:"\n",
		tab:"\t",
		curly: {
			open:"{",
			close:"}"
		},
		square: {
			open:"[",
			close:"]"
		},
		parentheses: {
			open:"(",
			close:")"
		},
		variable:"var",
		colon:":",
		comma:",",
		google: {
			_typedef:"@typedef",
			_param:"@param",
			_const:"@const",
			_implements:"@implements",
			_interface:"@interface",
			_return:"@return"
		},
		space:" ",
		empty:"",
		greater:">",
		lesser:"<",
		equals:"=",
		asterisk:"*",
		question_mark:"?",
		semicolon:";",
	}

	var api : JSGenApi;
	var buf : StringBuf;
	var bufA:Array<{n:String, b:StringBuf}>;
	//var bufA:Hash<StringBuf>;
	var inits : List<TypedExpr>;
	var statics : List<{ c : ClassType, f : ClassField }>;
	var packages : Hash<Bool>;
	var typedefs : Hash<Bool>;
	var forbidden : Hash<Bool>;
	var types:Hash<String>;
	var addFeature:Hash<Bool>;

	public function new(api) {
		this.api = api;
		tabs = 0;
		buf = new StringBuf();
		
		/**
		 * Create the array which will hold all the generated javascript
		 */
		bufA = new Array<{n:String, b:StringBuf}>();
		//bufA = new Hash<StringBuf>();
		
		/**
		 * Add the first string buffer
		 */
		bufA.push( { n:"DelkoEntry", b:buf } );
		//bufA.set("UhuEntry", buf);
		inits = new List();
		statics = new List();
		packages = new Hash();
		typedefs = new Hash();
		forbidden = new Hash();
		addFeature = new Hash<Bool>();
		
		types = new Hash<String>();
		types.set("Dynamic", "Object");
		types.set("Int", "number");
		types.set("Float", "number");
		types.set("Bool", "boolean");
		types.set("String", "string");
		types.set("null", characters.asterisk);
		types.set("Null", characters.question_mark);
		types.set("Void", characters.empty);
		
		for ( x in ["prototype", "__proto__", "constructor"] ) {
			forbidden.set(x, true);
		}
		
		api.setTypeAccessor(getType);
	}

	function getType( t : Type ) {
		return switch(t) {
			case TInst(c, _): 
				getPath(c.get());
				
			case TEnum(e, _): 
				getPath(e.get());
				
			case TAbstract(t, _):
				getPath(t.get());
				
			case _:
				throw "assert";
		};
	}
	
	function createFile(c:BaseType):Void {
		var path = getPath(c);
		if (path.lastIndexOf("#") != -1) return;
		for (b in bufA) {
			if (b.n == path) return;
		}
		//if (!bufA.exists(path)) {
			buf = new StringBuf();
			//bufA.push({n:getPath(c), b:buf});
			bufA.push({n:path, b:buf});
			//bufA.set(path, buf);
		/*} else {
			buf = bufA.get(path);
		}*/
	}

	function field(p) {
		return api.isKeyword(p) ? characters.square.open + "'" + p + "'" + characters.square.close : characters.dot + p;
	}
	
	function genPackage( p : Array<String> ) {
		var full = null;
		
		for( x in p ) {
			var prev = full;
			
			if( full == null ) full = x else full += characters.dot + x;
			if( packages.exists(full) ) continue;
			packages.set(full, true);
			
			addJavaDoc(["@type {Object}"]);
			
			if( prev == null )
				print(characters.variable + characters.space + x + " = " + characters.curly.open + characters.curly.close);
			else {
				var p = prev + field(x);
				//fprint("$p = {}");
				print(p + " = " + characters.curly.open + characters.curly.close);
			}
			
			newline();
		}
		
	}
	
	public function getPath( t : BaseType ) {
		var name = t.name;
		if (name.indexOf("#") != -1 ) name = "Static" + name.substr(1);
		return (t.pack.length == 0) ? name : t.pack.join(characters.dot) + characters.dot + name;
	}

	function checkFieldName( c : ClassType, f : ClassField ) {
		if ( forbidden.exists(f.name) ) {
			Context.error("The field " + f.name + " is not allowed in JS", c.pos);
		}
	}

	function genClassField( c : ClassType, p : String, f : ClassField ) {
		var field = field(f.name);
		var e = f.expr();
		
		addFieldAnnotation(f);
		checkFieldName(c, f);
		
		//fprint("${f.name}:");
		print('${f.name}:');
		
		if( e == null )
			print("null", false);
		else {
			genExpr(e, false);
		}
		
	}

	function genStaticField( c : ClassType, p : String, f : ClassField ) {
		var field = field(f.name);
		var e = f.expr();
		
		addFieldAnnotation(f);
		checkFieldName(c, f);
		
		if ( e == null ) {
			
			/**
			 * If the class has the neta tag @:exportProperties, then all fields
			 * become Class["field"] = {}.
			 */
			if (c.meta.has(":export") || c.meta.has(":exportProperties") || f.meta.has(":export") || f.meta.has(":exportProperties")) {
				//fprint('$p["${f.name}"] = null');
				print('$p["${f.name}"] = null');
			} else {
				//fprint('$p$field = null');
				print('$p$field = null');
			}
			
			newline(true);
			
		} else switch( f.kind ) {
			case FMethod(_):
				
				/**
				 * If the class has the neta tag @:exportProperties, then all fields
				 * become Class["field"] = {}.
				 */
				if (c.meta.has(":export") || c.meta.has(":exportProperties") ||f.meta.has(":export") || f.meta.has(":exportProperties")) {
					//fprint('$p["${f.name}"] = ');
					print('$p["${f.name}"] = ');
				} else {
					//fprint("$p$field = ");
					print('$p$field = ');
				}
				
				genExpr(e, false);
				
				newline();
			default:
				genStaticValue(c, f);
		}
		
		genExpose( { name:p + field, meta:f.meta } );
		
		newline();
		
	}
	
	/**
	 * Generates $hxExpose call
	 */
	function genExpose(t: { name:String, meta:MetaAccess } ) {
		
		if (t.meta.has(":expose")) {
			//fprint("$$hxExpose(${t.name}, ");
			print('$$hxExpose(${t.name}, ');
			
			for (m in t.meta.get()) {
				if (m.name == ":expose") {
					if (m.params.length != 0) {
						print(m.params[0].toString(), false);
					} else {
						//fprint("${t.name}", false);
						print('${t.name}', false);
					}
				}
			}
			
			print(characters.parentheses.close, false);
			
			newline(true);
		}
		
	}

	function genClass( c : ClassType ) {
		var p = getPath(c);
		//trace(c.meta.get());
		createFile(c);
		
		//tabs++;
		newline();
		
		genPackage(c.pack);
		api.setCurrentClass(c);
		
		/**
		 * Adds class google closure compiler compatible annotations
		 */
		addClassAnnotation(c);
		
		print(c.pack.length == 0 ? characters.variable + characters.space : characters.empty);
		
		//fprint("$p = ", false);
		print('$p = ', false);
		
		if ( c.constructor != null ) {
			genExpr(c.constructor.get().expr(), false);
		} else {
			print("function" + characters.parentheses.open + characters.parentheses.close + characters.space + characters.curly.open + characters.curly.close, false);
		}
		
		newline();
		
		genExpose( { name:p, meta:c.meta } );
		
		//fprint('$$hxClasses["$p"] = $p');
		print('$$hxClasses["$p"] = $p');
		
		newline(true, 1);
		
		for ( f in c.statics.get() ) {
			
			genStaticField(c, p, f);
		}
		
		var name = getPath(c).split(characters.dot).map(api.quoteString).join(characters.comma);
		
		addJavaDoc(["@type {Array.<string>}"]);
		//fprint("$p.__name__ = [$name]");
		print('$p.__name__ = [$name]');
		newline(true);
		
		if( c.interfaces.length > 0 ) {
			var me = this;
			var inter = c.interfaces.map(function(i) return me.getPath(i.t.get())).join(characters.comma);
			
			//fprint("$p.__interfaces__ = [$inter]");
			print('$p.__interfaces__ = [$inter]');
			newline(true);
		}
		
		if( c.superClass != null ) {
			var psup = getPath(c.superClass.t.get());
			
			//fprint("$p.__super__ = $psup");
			print('$p.__super__ = $psup');
			newline(true);
			
			//fprint("$p.prototype = $$extend($psup.prototype, { ");
			print('$p.prototype = $$extend($psup.prototype, { ');
		} else {
			//fprint("$p.prototype = { ");
			print('$p.prototype = { ');
		}
		
		tabs++;
		newline();
		
		//fprint("__class__:$p");
		print('__class__:$p');
		
		var i:Int = 0;
		
		for ( f in c.fields.get() ) {
			switch( f.kind ) {
				case FVar(r, _):
					if( r == AccResolve ) continue;
				default:
			}
			
			print(characters.comma, false);
			newline(false, 1);
			
			genClassField(c, p, f);
			
			++i;
		}
		
		tabs--;
		
		if (c.superClass != null) {
			newline();
			print(characters.curly.close + characters.parentheses.close);
			newline(true);
		} else {
			newline();
			print(characters.curly.close);
			newline();
		}
		
	}

	function genEnum( e : EnumType ) {
		var p = getPath(e);
		var names = p.split(characters.dot).map(api.quoteString).join(characters.comma);
		var constructs = e.names.map(api.quoteString).join(characters.comma);
		var meta = api.buildMetaData(e);
		
		createFile(e);
		
		newline(false, 1);
		genPackage(e.pack);
		
		addJavaDoc(["@type {{__ename__:Array.<string>, __constructs__:Array.<string>}}"]);
		print(e.pack.length == 0 ? "var " : "");
		//fprint("$p = { __ename__ : [$names], __constructs__ : [$constructs] }", false);
		print('$p = { __ename__ : [$names], __constructs__ : [$constructs] }', false);
		newline();
		//fprint('$$hxClasses["$p"] = $p');
		print('$$hxClasses["$p"] = $p');
		newline(true);
		
		for( c in e.constructs.keys() ) {
			var c = e.constructs.get(c);
			var f = field(c.name);
			
			switch( c.type ) {
				case TFun(args, _):
					//fprint('$p$f = ');
					print('$p$f = ');
					var sargs = args.map(function(a) return a.name).join(characters.comma);
					//fprint('function($sargs) { var $$x = ["${c.name}",${c.index},$sargs]; $$x.__enum__ = $p; $$x.toString = $$estr; return $$x; }', false);
					print('function($sargs) { var $$x = ["${c.name}",${c.index},$sargs]; $$x.__enum__ = $p; $$x.toString = $$estr; return $$x; }', false);
					newline();
				default:
					addJavaDoc(["@type {Array.<(string|number)>}"]);
					//fprint('$p$f = ');
					print('$p$f = ');
					print(characters.square.open + api.quoteString(c.name) + characters.comma + c.index + characters.square.close, false);
					newline(true);
					
					addJavaDoc([characters.google._return + " {string}"]);
					//fprint('$p$f.toString = $$estr');
					print('$p$f.toString = $$estr');
					newline(true);
					
					addJavaDoc(["@type {" + p + "}"]);
					//fprint("$p$f.__enum__ = $p");
					print('$p$f.__enum__ = $p');
					newline(true);
			}
			
		}
		
		if( meta != null ) {
			//fprint("$p.__meta__ = ");
			print('$p.__meta__ = ');
			genExpr(meta);
			newline();
		}
		
	}
	
	/**
	 * This is a, hopefully temporary, fix to $iterator appearing in the
	 * output. 
	 */
	public function genExtern(c:ClassType):Void {
		
		for (f in c.fields.get()) {
			
			if (f.meta.has(":runtime") && f.name == "iterator") {
				addFeature.set("$iterator", true);
				addFeature.set("$bind", true);
			}
			
		}
	}

	function genStaticValue( c : ClassType, cf : ClassField ) {
		var p = getPath(c);
		var f = field(cf.name);
		
		/**
		 * If the class has the neta tag @:exportProperties, then all fields
		 * become Class["field"] = {}.
		 */
		if (c.meta.has(":export") || c.meta.has(":exportProperties") || cf.meta.has(":export") || cf.meta.has(":exportProperties")) {
			//fprint('$p["${cf.name}"] = ');
			print('$p["${cf.name}"] = ');
		} else {
			//fprint("$p$f = ");
			print('$p$f = ');
		}
		
		genExpr(cf.expr(), false);
		newline(true);
	}

	function genType( t : Type ) {
		switch( t ) {
			case TInst(c, _):
				var c = c.get();
				if( c.init != null )
					inits.add(c.init);
				if ( !c.isExtern ) {
					genClass(c);
				} else {
					genExtern(c);
				}
			case TEnum(r, _):
				var e = r.get();
				if( !e.isExtern ) genEnum(e);
			case _:
		}
	}

	public function generate() {
		
		var entryBuffer:StringBuf = buf;
		
		if (Context.defined("js_modern")) {
			print(" 'use strict';");
		}
		
		newline();
		
		tabs++;
		newline();
		
		addJavaDoc(["@type {*}"]);
		print(characters.variable + " $_ = {}");
		newline(true, 1);
		
		addJavaDoc(["@type {Object.<string, *>}"]);
		print(characters.variable + " $hxClasses = {}");
		newline(true, 1);
		
		addJavaDoc([characters.google._return + " {string}"]);
		printParts( [
			"function $estr() {",
			"\treturn js.Boot.__string_rec(this, '');",
			"}"]
		);
		
		newline();
		
		addJavaDoc(["@param {Object} from", "@param {Object.<string, Object>} fields"]);
		printParts(
			[
			"function $extend(from, fields) {",
				"\t/** @constructor */",
				"\tfunction inherit() {};",
				"\tinherit.prototype = from;", 
				"\tvar proto = new inherit();",
				"\tfor (var name in fields) proto[name] = fields[name];",
				"\treturn proto;",
			"}"
			]
		);
		
		newline();
		
		addJavaDoc(["@param {Object} src", "@param {string} path"]);
		printParts(
			[
			"function $hxExpose(src, path) {",
				"\t/** @type {Window} */", 
				"\tvar o = typeof window != \"undefined\" ? window : exports;", 
				"\t/** @type {Array.<string>} */", 
				"\tvar parts = path.split('.');", 
				"\tfor (var ii = 0; ii < parts.length-1; ++ii) {", 
					"\t\tvar p = parts[ii];",
					"\t\tif(typeof o[p] == 'undefined') o[p] = {};",
					"\t\to = o[p];",
				"\t}",
				"\to[parts[parts.length-1]] = src;",
			"}"
			]
		);
		
		for( t in api.types ) {
			genType(t);
		}
		
		newline();
		addJavaDoc(["@type {*}"]);
		print("js.Boot.__res = {}");
		//newline();
		//print("js.Boot.__init()");
		newline(true);
		
		/**
		 * Generate code for all __init__ methods
		 */
		for ( e in inits ) {
			var string = api.generateStatement(e);
			string = string.replace(characters.newline, characters.newline + repeat(characters.tab, tabs));
			print(string);
			newline(string.trim().endsWith("}") ? false : true);
		}
		
		/**
		 * Generate code for all static fields
		 */
		for( s in statics ) {
			genStaticValue(s.c,s.f);
			newline();
		}
		
		/**
		 * Generate code for the entry point
		 */
		if( api.main != null ) {
			genExpr(api.main);
			newline();
		}
		
		tabs--;
		newline();
		
		buf = entryBuffer;
		if (addFeature.exists("$bind")) {
			print("var $_");
			newline(true);
			print("function $bind(o,m) { var f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; return f; }");
			newline();
		}
		
		if (addFeature.exists("$iterator")) {
			print("function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }");
			newline();
		}
		
		var sep = massive.neko.io.File.seperator;
		var dir = massive.neko.io.File.create(FileSystem.fullPath(api.outputFile));
		var uhu = massive.neko.io.File.create(PathUtil.cleanUpPath(dir.parent.nativePath + sep + "fragments"), null, true);
		var file = null;
		var out = "";
		/**
		 * Loop through the string buffer array, write the content of each to a file.
		 * Replace all occurances of .$bind with ["$bind"]. Prevents google closure compiler
		 * from tripping as Boot.hx sets it as Function.prototype["$bind"].
		 */
		for (f in bufA) {
			out = f.b.toString();
			out = out.replace(".abstract", ".delkoabstract");
			out = out.replace("'abstract'", "'delkoabstract'");
			file = sys.io.File.write(PathUtil.cleanUpPath(uhu.nativePath + sep + f.n + ".js"), true);
			file.writeString(out);
			file.close();
		}
		
		/**
		 * Create three .bat files, which allow you to run 
		 * google closure compiler in each compression level. 
		 * 
		 * Im so thoughtful :D
		 */
		for (op in ["WHITESPACE_ONLY", "SIMPLE_OPTIMIZATIONS", "ADVANCED_OPTIMIZATIONS"]) {
			file = sys.io.File.write(dir.parent.nativePath + sep + 'closure_compiler_${op.toLowerCase()}.bat', true);
			file.writeString('java -jar compiler.jar --output_wrapper "(function(context) {%%output%%})(window);${if(Context.defined("debug")){"//@ sourceMappingURL=" + dir.fileName + ".map";}}" ${if(Context.defined("debug")){"--formatting=pretty_print";}else{"";}} --create_source_map=./${dir.fileName}.map --source_map_format=V3 --compilation_level ${op} --js_output_file ${dir.fileName} ');
			
			//for (f in bufA.keys()) {
			for (f in bufA) {
				file.writeString("--js ." + sep + "fragments" + sep + f.n + ".js ");
			}
			
			file.close();
		}
	}
	
	/**
	 * -------------------------
	 * DELKO METHODS AND VARIABLES
	 * -------------------------
	 */ 
	
	public var tabs:Int;
	
	public function genExpr(e, ?tab:Bool = true) {
		var _str:String = api.generateValue(e).replace(characters.newline, characters.newline + repeat(characters.tab, tabs));
		print(_str, tab);
	}
	
	/*@:macro	public static function fprint(e:Expr , ?tab:Bool = true) {
		var pos = haxe.macro.Context.currentPos();
		var ret = haxe.macro.Format.format(e);
		var boo = Context.parse(Std.string(tab), pos);
		return { expr : ECall({ expr : EConst(CIdent("print")), pos : pos },[ret, boo]), pos : pos };
	}*/
	
	public function print(str:String, ?tab:Bool = true) {
		buf.add((tab ? repeat(characters.tab, tabs) : characters.empty) + str);
	}
	
	public function newline(?semicolon:Bool = false, ?extra:Int = 0) {
		buf.add((semicolon ? characters.semicolon : characters.empty) + characters.newline + repeat(characters.newline, extra));
	}
	
	public function repeat(s : String, times : Int)	{
		var result = characters.empty;
		
		for (i in 0...times) {
			result += s;
		}
		return result;
	}
	
	/**
	 * Prints the passed array values. Seemed like a good idea...
	 */
	public function printParts(value:Array<String>):Void {
		for (v in value) {
			print(v);
			newline();
		}
	}
	
	/**
	 * Adds javadoc style annotations above the current field
	 */
	public function addJavaDoc(comments:Array<String>):Void {
		var i:Int = 0;
		if (comments.length > 0) {
			print("/**");
			if (comments.length != 1) newline();
			for (comment in comments) {
				if (comments.indexOf(comment) == i) {
					if (comments.length != 1) {
						//fprint("* $comment");
						print('* $comment');
						newline();
					} else {
						//fprint(" $comment ", false);
						print(' $comment ', false);
					}
				}
				i++;
			}
			print("*/", comments.length == 1 ? false : true);
			newline();
		}
	}
	
	public function printAccess(field:{isPublic:Bool}):String {
		return field.isPublic ? characters.empty : "@private";
	}
	
	/**
	 * Checks the type for a google closure compiler
	 * annotations match and returns it.
	 */
	public inline function checkType(type:String):String {
		return (types.exists(type)) ? types.get(type) : type;
	}
	
	private static var _typePartCache:Hash<String> = new Hash<String>();
	private static var _typeResultCache:Hash<String> = new Hash();
	/**
	 * DELKO GOD!
	 */
	public function buildRecordType(type:Type, ?data: { parent:BaseType, params:Array<Type> } ):String {
		var name = Std.string(type);
		var result = _typeResultCache.get(name);
		
		if (result == null) {
			switch(type) {
				/**
				 * If not null, then send back through buildRecordType and return
				 */
				case TMono(_t):
					var mono = _t.get();
					if (mono != null) {
						result = buildRecordType(mono);
					} else {
						result = checkType(Std.string(mono));
					}
				
				/**
				 * Build value. If it has params, then output jsdoc style type application
				 * e.g Array.<string> or Object.<string, number>
				 */
				case TEnum(_t, _p):
					var enm:EnumType = _t.get();
					
					if (!_typePartCache.exists(enm.name)) {
						
						result = checkType(getPath(enm));
						if (_p.length != 0) {
							result += characters.dot + characters.lesser;
							for (param in _p) {
								if (param != _p[0]) result += characters.comma + characters.empty;
								result += buildRecordType(param);
							}
							result += characters.greater;
						}
						
						_typePartCache.set(enm.name, result);
						
					} else {
						result = _typePartCache.get(enm.name);
					}
				
				/**
				 * Build class string. 
				 * 
				 * Filter type inference e.g Array.T
				 * 
				 * Filter xirsys_stdjs paths and only used the class or typedef name,
				 * e.g. js.w3c.html5.Core.HTMLElement becomes HTMLElement. I assume as
				 * xirsys_stdjs is said to be based/parsed off w3c specs, they should
				 * match up with google closure compilers extern files, which allow it to
				 * do more inlining and optimisation. Crude detection of js.w3c or js.webgl
				 * :(
				 * 
				 */
				case TInst(_t, _p):
					var cls:ClassType = _t.get();
					
					result = getPath(cls);
					/*
					 * Should detect things like indexOf.T, or indexOf.TA
					 * or indexOf.TAADSDSDS
					 */ 
					var typedParam:EReg = ~/\.[A-Z]+$/;
					
					/*
					 * Should detect most? of xirsys_stdjs
					 */
					var stdjs:EReg = ~/^js\.(w3c|webgl)\./i;
					
					if (typedParam.match(result)) {
						/**
						 * Only remove the last value if its first character
						 * is not lowercase - this means it a package name.
						 * Class names in most cases start with Uppercase
						 * character. Poor mans check...
						 */
						var _array = result.split(characters.dot);
						var _fchar = _array[_array.length - 2].substr(0, 1);
						
						if (_fchar == _fchar.toUpperCase()) {
							result = _array.splice(0, _array.length - 1).join(characters.dot);
						}
						
					}
					
					result = checkType(result);
					
					if (result == characters.question_mark) result += characters.asterisk;
					
					/*
					 * Only if xirsys_stdjs is being used
					 */
					if (Context.defined("xirsys_stdjs") && stdjs.match(result)) {
						var _array = result.split(characters.dot);
						result = _array[_array.length-1];
					}
					
					if (_p.length != 0) {
						result += characters.dot + characters.lesser;
						for (param in _p) {
							if (param != _p[0]) result += characters.comma + characters.space;
							result += buildRecordType(param);
						}
						result += characters.greater;
					}
					
					_typePartCache.set(cls.name, result);
					
				/**
				 * Pass typedef back through buildRecordType and return
				 */
				case TType(_t, _p):
					result = buildRecordType(_t.get().type, { parent:cast _t.get(), params:_p } );
				
				/**
				 * Build jsdoc function definition, usually used for param/typedef sigs
				 */
				case TFun(_a, _r):
					var _return = buildRecordType(_r);
					result = "function" + characters.parentheses.open;
					for (arg in _a) {
						if (arg != _a[0]) result += characters.comma;
						result += buildRecordType(arg.t);
						if (arg.opt) result += characters.equals;
					}
					result += characters.parentheses.close;
					if (_return != characters.empty) result += characters.colon + _return;
				
				/**
				 * Usually builds typedefs, which is why TAnonymous builds two different outputs,
				 * a google closure compiler typedef and a truely anonymous sig.
				 */
				case TAnonymous(_a):
					result = "TAnonymous";
					
					if (data != null) {
						
						var def:BaseType = data.parent;
						name = def.name;
						
						result = checkType(getPath(def));
						var anon:AnonType = _a.get();
						
						if (!typedefs.exists(result) && anon.fields.length != 0) {
							var javaDoc = new Array<String>();
							var output = characters.google._typedef + characters.space + characters.curly.open + characters.curly.open;
							var prevBuf = buf;
							var prevTab = tabs;
							
							typedefs.set(result, true);
							
							createFile(def);
							tabs = 1;
							
							genPackage(def.pack);
							
							for (f in anon.fields) {
								if (f != anon.fields[0]) output += characters.comma + characters.space;
								output += f.name + characters.colon + buildRecordType(f.type);
							}
							
							output += characters.curly.close + characters.curly.close;
							
							javaDoc.push(output);
							
							addJavaDoc(javaDoc);
							
							(def.pack.length == 0 ? print(characters.variable + characters.space) : characters.empty);
							
							//(def.pack.length == 0 ?	fprint("$result", false) : print(result));
							(def.pack.length == 0 ?	print('$result', false) : print(result));
							newline(true);
							
							
							
							buf = prevBuf;
							tabs = prevTab;
						}
						
					} else {
						var anon:AnonType = _a.get();
						result = characters.curly.open;
						for (f in anon.fields) {
							if (f != anon.fields[0]) result += characters.comma + characters.space;
							result += f.name + characters.colon + buildRecordType(f.type);
						}
						result += characters.curly.close;
					}
				
				/**
				 * If not null, send back through buildRecordType and return
				 */
				case TDynamic(_t):
					if (_t != null) {
						result = buildRecordType(_t);
					} else {
						result = checkType(Std.string(_t));
					}
					
				/**
				 * Havnt done this yet...
				 */
				case TLazy(_):
					result = "TLazy";
				default:
					result = characters.empty;
			}
			_typeResultCache.set(name, result);
		}
		
		return result;
	}
	
	/**
	 * Google closure compiler annotations
	 * https://developers.google.com/closure/compiler/docs/js-for-compiler
	 */
	public function printType(type:Type, ?optional:Bool = false):String {
		var _type = buildRecordType(type);
		
		if (optional) _type += characters.equals;
		
		return _type;
		
	}
	
	public function addFieldAnnotation(field:ClassField, ?self:String = "|"):Void {
		
		var javaDocs:Array<String> = new Array<String>();
		var fieldAccess:String = printAccess(field);
		var type:String;
		
		if (fieldAccess != characters.empty) javaDocs.push(printAccess(field));
		
		var annotated:Hash<Array<String>> = new Hash<Array<String>>();
		
		if (field.meta.has(":annotate")) {
			for (m in field.meta.get()) {
				if (m.name == ":annotate") {
					for (p in m.params) {
						switch(p.expr) {
							case EFunction(_, f):
								for (a in f.args) {
									if (!annotated.exists(a.name)) {
										annotated.set( a.name, [a.type.toString()] );
									} else {
										annotated.get(a.name).push( a.type.toString() );
									}
								}
								if (f.ret != null) {
									if (!annotated.exists("return")) {
										annotated.set( "return", [f.ret.toString()] );
									} else {
										annotated.get("return").push( f.ret.toString() );
									}
								}
							default:
						}
					}
				}
			}
		}
		
		switch (field.kind) {
			case FMethod(_):
				
				switch (field.type) {
					
					case TFun(_args, _return):
						for (_arg in _args) {
							if (printType(_arg.t) == "*" && annotated.count() != 0) {
								type = "{" + annotated.get(_arg.name).join("|") + "}";
							} else {
								type = printType(_arg.t, _arg.opt);
							}
							if (type == self) type = "Object";
							javaDocs.push (characters.google._param + characters.space + characters.curly.open + type + characters.curly.close + characters.space + _arg.name);
						}
						
						if (printType(_return) != characters.empty) {
							if (printType(_return) == "*" && annotated.count() != 0) {
								type = "{" + annotated.get("return").join("|") + "}";
							} else {
								type = printType(_return);
							}
							if (type == self) type = "Object";
							javaDocs.push(characters.google._return + characters.space + characters.curly.open + type + characters.curly.close);
						}
						
					case _:
				}
				
			case FVar(_read, _write):
				
				if (_read == VarAccess.AccInline && _write == VarAccess.AccNever) javaDocs.push(characters.google._const);
				javaDocs.push("@type " + characters.curly.open + characters.question_mark + printType(field.type) + characters.curly.close);
				
			//case _:
		}
		
		addJavaDoc(javaDocs);
	}
	
	public function addClassAnnotation(_class:ClassType):Void {
		
		var superClass:ClassType;
		var javaDoc:Array<String> = new Array<String>();
		
		/**
		 * I used to type constructors as @constructor, static classes as @const, 
		 * but found that ADVANCED mode of google closure compiler removed static 
		 * fields from classes with constructors, which cause reflection issues.
		 * 
		 * Marking every class, static or not with @const allows successful minification,
		 * but outputs a boat load more warnings, mainly about the dangerous use of "this".
		 * 
		 * Code will be kept commented out.
		 */
		/*if (!_class.isInterface && _class.constructor != null) javaDoc.push("@const");//javaDoc.push("@constructor");
		
		if (_class.constructor == null && _class.interfaces.length == 0) {
			javaDoc.push("@const");
		} else {
			//javaDoc.push("@constructor");
			javaDoc.push("@const");
		}*/
		javaDoc.push(characters.google._const);
		
		if (_class.isInterface) javaDoc.push(characters.google._interface);
		
		if (_class.superClass != null) {
			superClass = _class.superClass.t.get();
			javaDoc.push("@extends " + (superClass.pack.length > 0 ? superClass.pack.join(characters.dot) + characters.dot : characters.empty) + superClass.name);
		}
		
		if (_class.interfaces.length != 0) {
			for (inter in _class.interfaces) {
				javaDoc.push(characters.google._implements + characters.space + characters.curly.open + inter.t.get().module + characters.curly.close);
			}
		}
		
		if (_class.constructor != null) {
			switch (_class.constructor.get().type) {
				case TFun(_args, _):
					for (_arg in _args) {
						javaDoc.push(characters.google._param + characters.space + characters.curly.open + printType(_arg.t, _arg.opt) + characters.curly.close + characters.space + _arg.name);
					}
				default:
			}
		}
		
		addJavaDoc(javaDoc);
		
	}
	
	#if macro
	public static function use() {
		Compiler.setCustomJSGenerator(function(api) new Delko(api).generate());
	}
	#end
	
}