package uhu.js;

import haxe.macro.Tools;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.JSGenApi;
import haxe.macro.Compiler;
import haxe.macro.ExampleJSGenerator;
import uhu.js.delko.t.TBuffered;
import sys.FileSystem;
import uhu.macro.Jumla;

import massive.neko.io.FileSys;
import massive.neko.util.PathUtil;

import sys.io.File;
import sys.io.FileOutput;

using uhu.macro.Jumla;
using Lambda;
using StringTools;

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

class Delko  {
	
	public static var characters = {
		google: {
			_typedef:"@typedef",
			_param:"@param",
			_const:"@const",
			_implements:"@implements",
			_interface:"@interface",
			_return:"@return"
		},
	}

	var api:JSGenApi;
	//var buf:StringBuf;
	var fragment:TBuffered;
	//var bufA:Array<{ name:String, buffer:StringBuf }>;
	var bufA:Array<TBuffered>;
	var inits:List<TypedExpr>;
	var statics:List<{ c : ClassType, f : ClassField }>;
	var packages:Hash<Bool>;
	var typedefs:Hash<Bool>;
	var forbidden:Hash<Bool>;
	var types:Hash<String>;
	var addFeature:Hash<Bool>;
	
	public var hasExpose:Bool = false;
	public var doesExtend:Bool = false;
	public var hasEnum:Bool = false;
	public var has__class__:Bool = false;
	public var has__className__:Bool = false;
	public var has__enumName__:Bool = false;
	public var has__superClass__:Bool = false;
	public var has__properties__:Bool = false;
	public var has__interfaces__:Bool = false;
	public var has__enum__:Bool = false;
	public var has__hxClasses__:Bool = false;

	public function new(api) {
		this.api = api;
		tabs = 0;
		
		//buf = new StringBuf();
		
		/**
		 * Create the array which will hold all the generated javascript
		 */
		//bufA = new Array<{ name:String, buffer:StringBuf }>();
		bufA = new Array<TBuffered>();
		
		/**
		 * Add the first string buffer
		 */
		//bufA.push( { name:"DelkoEntry", buffer:buf } );
		fragment = { name:'DelkoEntry', parts:[] };
		bufA.push( fragment );
		
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
		types.set("null", '*');
		types.set("Null", '?');
		types.set("Void", '');
		
		for (x in ["prototype", "__proto__", "constructor"]) {
			forbidden.set(x, true);
		}
		
		api.setTypeAccessor(getType);
	}

	function getType(t:Type) {
		
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
			
			if (b.name == path) return;
			
		}
		
		//buf = new StringBuf();
		fragment = { name:path, parts:[] };
		//bufA.push( { name:path, buffer:buf } );
		bufA.push( fragment );
	}

	function field(p) {
		return api.isKeyword(p) ? '[\'$p\']' : '.$p';
	}
	
	function genPackage(p:Array<String>) {
		var full = null;
		
		for( x in p ) {
			var prev = full;
			
			if (full == null) {
				full = x;
			} else {
				full += '.$x';
			}
			
			if (packages.exists(full)) {
				continue;
			}
			
			packages.set(full, true);
			
			addJavaDoc(["@type {Object}"]);
			
			if( prev == null ) {
				print('var $x = {}');
			} else {
				var p = prev + field(x);
				print('$p = {}');
			}
			
			newline();
		}
		
	}
	
	public function getPath(t:BaseType) {
		var name = t.name;
		
		checkMeta( t );
		
		if (name.indexOf("#") != -1 ) name = "Static" + name.substr(1);
		return (t.pack.length == 0) ? name : t.pack.join('.') + '.$name';
	}
	
	function checkFieldName(c : ClassType, f : ClassField) {
		if ( forbidden.exists(f.name) ) {
			Context.error('The field ${f.name} is not allowed in JS', c.pos);
		}
	}
	
	function genClassField(c : ClassType, p : String, f : ClassField) {
		
		checkMeta( f );
		
		var field = field(f.name);
		var e = f.expr();
		var match = false;
		
		if (c.superClass != null) {
			
			var sfields = c.superClass.t.get().fields.get();
			
			if (sfields.length != 0) {
				
				for (s in sfields) {
					if (s.name == f.name) {
						match = true;
						break;
					}
				}
				
			}
			
		}
		
		addFieldAnnotation(f, match);
		checkFieldName(c, f);
		
		print('${f.name}:');
		
		if (e == null) {
			print("null", false);
		} else {
			genExpr(e, false);
		}
		
	}

	function genStaticField(c : ClassType, p : String, f : ClassField) {
		
		checkMeta( f );
		
		var field = field(f.name);
		var e = f.expr();
		
		addFieldAnnotation(f);
		checkFieldName(c, f);
		
		if (e == null) {
			
			/**
			 * If the class has the neta tag @:exportProperties, then all fields
			 * become Class["field"] = {}.
			 */
			if (c.meta.has(":export") || c.meta.has(":exportProperties") || f.meta.has(":export") || f.meta.has(":exportProperties")) {
				print('$p["${f.name}"] = null');
			} else {
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
					print('$p["${f.name}"] = ');
				} else {
					print('$p$field = ');
				}
				
				genExpr(e, false);
				
				newline();
			default:
				genStaticValue(c, f);
		}
		
		//genExpose( { name:p + field, meta:f.meta } );
		
		newline();
		
	}
	
	public function checkMeta(b:{ name:String, meta:MetaAccess }) {
		
		for (meta in b.meta.get()) {
			
			switch (meta.name) {
				
				case ':expose':
					genExpose( b );
				case ':defineFeature':
					
				case _:
				
			}
			
		}
		
	}
	
	public function checkSpecials(c:ClassType, f:ClassField) {
		var name = getPath( c ) + '.' + f.name;
		
		switch (name) {
			case 'Type.getClass' | 'Boot.getClass':
				has__class__ = true;
				
			case 'Type.getEnum' | 'Type.enumEq':
				has__enum__ = true;
				
			case 'Type.getSuperClass':
				has__superClass__ = true;
				
			case 'Type.getClassName' | 'Boot.isClass':
				has__className__ = true;
				
			case 'Type.getEnumName' | 'Boot.isEnum':
				has__enumName__ = true;
				
			case 'Type.resolveClass' | 'Type.resolveEnum':
				has__hxClasses__ = true;
				
			case 'Reflect.getProperty' | 'Reflect.setProperty':
				has__properties__ = true;
				
			case _:
				
		}
	}
	
	/**
	 * Generates $hxExpose call if `:expose` is found
	 */
	function genExpose(t: { name:String, meta:MetaAccess } ) {
		
		if (!hasExpose) {
			
			var previousFragment = fragment;
			var currentFragment = null;
			
			for (fragment in bufA) {
				if (fragment.name == 'DelkoEntry') {
					currentFragment = fragment;
					break;
				}
			}
			
			fragment = currentFragment;
			
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
			
			hasExpose = true;
			
		}
		
		if (t.meta.has(":expose")) {
			print('$$hxExpose(${t.name}, ');
			
			for (meta in t.meta.get()) {
				
				if (meta.name == ":expose") {
					
					if (meta.params.length != 0) {
						print(meta.params[0].toString(), false);
					} else {
						print('${t.name}', false);
					}
					
				}
				
			}
			
			print(')', false);
			
			newline(true);
		}
		
	}

	public function genExtends() {
		if (!doesExtend) {
			
			var previousFragment = fragment;
			var currentFragment = null;
			
			for (fragment in bufA) {
				if (fragment.name == 'DelkoEntry') {
					currentFragment = fragment;
					break;
				}
			}
			
			fragment = currentFragment;
			
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
			
			doesExtend = true;
			
		}
	}
	
	function genClass(c:ClassType) {
		var p = getPath(c);
		
		if (c.superClass != null)  {
			genExtends();
		}
		
		createFile(c);
		newline();
		
		genPackage(c.pack);
		api.setCurrentClass(c);
		
		/**
		 * Adds class google closure compiler compatible annotations
		 */
		addClassAnnotation(c);
		
		print(c.pack.length == 0 ? 'var ' : '');
		print('$p = ', false);
		
		if (c.constructor != null) {
			genExpr(c.constructor.get().expr(), false);
		} else {
			print('function() {}', false);
		}
		
		newline();
		
		//genExpose( { name:p, meta:c.meta } );
		
		print('$$hxClasses["$p"] = $p');
		
		newline(true, 1);
		
		for (f in c.statics.get()) {
			genStaticField(c, p, f);
		}
		
		var name = getPath(c).split('.').map(api.quoteString).join(',');
		
		addJavaDoc(["@type {Array.<string>}"]);
		print('$p.__name__ = [$name]');
		newline(true);
		
		if( c.interfaces.length > 0 ) {
			var me = this;
			var inter = c.interfaces.map(
				function(i) { 
					return me.getPath( i.t.get() );
				}
			).join(',');
			
			print('$p.__interfaces__ = [$inter]');
			newline(true);
		}
		
		if(c.superClass != null) {
			var psup = getPath(c.superClass.t.get());
			
			print('$p.__super__ = $psup');
			newline(true);
			
			print('$p.prototype = $$extend($psup.prototype, { ');
		} else {
			print('$p.prototype = {');
		}
		
		tabs++;
		newline();
		
		print('__class__:$p');
		
		var i:Int = 0;
		
		for (f in c.fields.get()) {
			
			switch( f.kind ) {
				case FVar(r, _):
					
					if (r == AccResolve) {
						continue;
					}
					
				case _:
			}
			
			print(',', false);
			newline(false, 1);
			
			genClassField(c, p, f);
			
			++i;
		}
		
		tabs--;
		
		if (c.superClass != null) {
			newline();
			print('})');
			newline(true);
		} else {
			newline();
			print('}');
			newline();
		}
		
	}

	function genEnum(e:EnumType) {
		hasEnum = true;
		
		var p = getPath(e);
		var names = p.split('.').map(api.quoteString).join(',');
		var constructs = e.names.map(api.quoteString).join(',');
		var meta = api.buildMetaData(e);
		
		createFile(e);
		
		newline(false, 1);
		genPackage(e.pack);
		
		addJavaDoc(["@type {{__ename__:Array.<string>, __constructs__:Array.<string>}}"]);
		print(e.pack.length == 0 ? "var " : "");
		print('$p = { __ename__ : [$names], __constructs__ : [$constructs] }', false);
		
		newline();
		
		print('$$hxClasses["$p"] = $p');
		newline(true);
		
		for( c in e.constructs.keys() ) {
			var c = e.constructs.get(c);
			var f = field(c.name);
			
			switch( c.type ) {
				case TFun(args, _):
					
					print('$p$f = ');
					var sargs = args.map(function(a) return a.name).join(',');
					print('function($sargs) { var $$x = ["${c.name}",${c.index},$sargs]; $$x.__enum__ = $p; $$x.toString = $$estr; return $$x; }', false);
					newline();
					
				case _:
					
					addJavaDoc(["@type {Array.<(string|number)>}"]);
					print('$p$f = ');
					print('[' + api.quoteString(c.name) + ',' + c.index + ']', false);
					newline(true);
					
					addJavaDoc([characters.google._return + " {string}"]);
					print('$p$f.toString = $$estr');
					newline(true);
					
					addJavaDoc(["@type {" + p + "}"]);
					print('$p$f.__enum__ = $p');
					newline(true);
					
			}
			
		}
		
		if (meta != null) {
			
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
			print('$p["${cf.name}"] = ');
		} else {
			print('$p$f = ');
		}
		
		genExpr(cf.expr(), false);
		newline(true);
	}

	function genType( t : Type ) {
		
		switch(t) {
			
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
				
				if (!e.isExtern) {
					genEnum(e);
				}
				
			case _:
		}
		
	}

	public function generate() {
		
		//var entryBuffer:StringBuf = buf;
		var entryFragment = fragment;
		
		if (Context.defined("js_modern")) {
			print(" 'use strict';");
		}
		
		newline();
		newline();
		
		addJavaDoc(["@type {*}"]);
		print('var $$_ = {}');
		newline(true, 1);
		
		/*addJavaDoc(["@type {Object.<string, *>}"]);
		print('var $$hxClasses = {}');
		newline(true, 1);*/
		fragment.parts.push( function() {
			var out = '';
			
			if (has__hxClasses__) {
				
				out += "@type {Object.<string, *>}\n";
				out += "var $hxClasses = {}\n";
				
			}
			
			return out;
		} );
		
		/*addJavaDoc([characters.google._return + " {string}"]);
		printParts( [
			"function $estr() {",
			"\treturn js.Boot.__string_rec(this, '');",
			"}"]
		);*/
		fragment.parts.push( function() {
			var out = '';
			
			if (hasEnum) {
				
				out += characters.google._return + ' {string}\n';
				out += "function $estr() {\n";
				out += "\treturn js.Boot.__string_rec(this, '');\n";
				out += "}\n";
				
			}
			
			return out;
		} );
		
		newline();
		
		for(t in api.types) {
			genType(t);
		}
		
		newline();
		
		addJavaDoc(["@type {*}"]);
		print("js.Boot.__res = {}");
		
		newline(true);
		
		/**
		 * Generate code for all __init__ methods
		 */
		/*for ( e in inits ) {
			var string = api.generateStatement(e);
			string = string.replace('\n', '\n' + repeat('\t', tabs));
			print(string);
			newline(string.trim().endsWith("}") ? false : true);
		}*/
		
		/**
		 * Generate code for all static fields
		 */
		for (s in statics) {
			
			genStaticValue(s.c,s.f);
			newline();
			
		}
		
		/**
		 * Generate code for the entry point
		 */
		if (api.main != null) {
			
			genExpr(api.main);
			newline();
			
		}
		
		tabs--;
		newline();
		
		//var initBuf = new StringBuf();
		var initFragment:TBuffered = { name:'DelkoInits', parts:[] };
		//bufA.push( { name:'DelkoInits', buffer:initBuf } );
		bufA.push( initFragment );
		//buf = initBuf;
		fragment = initFragment;
		
		/**
		 * Generate code for all __init__ methods
		 */
		for (e in inits) {
			
			addJavaDoc( [ '@this {?}' ] );
			var string = api.generateStatement(e);
			string = string.replace('\n', '\n' + repeat('\t', tabs));
			print(string);
			newline( (string.trim().endsWith("}") ? false : true), 1);
			
		}
		
		//buf = entryBuffer;
		fragment = entryFragment;
		
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
		//var out = '';
		
		/**
		 * Loop through the string buffer array, write the content of each to a file.
		 * Replace all occurances of .$bind with ["$bind"]. Prevents google closure compiler
		 * from tripping as Boot.hx sets it as Function.prototype["$bind"].
		 */
		for (f in bufA) {
			var out = '';
			//out = f.buffer.toString();
			for (p in f.parts) {
				out += p();
			}
			
			out = out.replace(".abstract", ".delkoabstract");
			out = out.replace("'abstract'", "'delkoabstract'");
			file = sys.io.File.write(PathUtil.cleanUpPath(uhu.nativePath + sep + f.name + ".js"), true);
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
			file.writeString('java -jar compiler.jar --output_wrapper "(function(context) { \\"use strict\\"; %%output%%})(window);${if(Context.defined("debug")){"//@ sourceMappingURL=" + dir.fileName + ".map";}}" ${if(Context.defined("debug")){"--formatting=pretty_print";}else{"";}} --create_source_map=./${dir.fileName}.map --source_map_format=V3 --compilation_level ${op} --js_output_file ${dir.fileName} ');
			
			for (f in bufA) {
				file.writeString("--js ." + sep + "fragments" + sep + f.name + ".js ");
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
		var _str:String = api.generateValue(e).replace('\n', '\n' + repeat('\t', tabs));
		print(_str, tab);
	}
	
	public function print(str:String, ?tab:Bool = true) {
		//buf.add((tab ? repeat('\t', tabs) : '') + str);
		fragment.parts.push( function() {
			return (tab ? repeat('\t', tabs) : '') + str;
		} );
	}
	
	public function newline(?semicolon:Bool = false, ?extra:Int = 0) {
		//buf.add((semicolon ? ';' : '') + '\n' + repeat('\n', extra));
		fragment.parts.push( function() {
			return (semicolon ? ';' : '') + '\n' + repeat('\n', extra);
		} );
	}
	
	public function repeat(s : String, times : Int)	{
		var result = '';
		
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
			if (comments.length != 1) {
				newline();
			}
			
			for (comment in comments) {
				
				if (comments.indexOf(comment) == i) {
					if (comments.length != 1) {
						
						print('* $comment');
						newline();
						
					} else {
						
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
		return field.isPublic ? '' : "@private";
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
							
							result += '.<';
							
							for (param in _p) {
								
								if (param != _p[0]) result += ',';
								result += buildRecordType(param);
								
							}
							
							result += '>';
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
						var _array = result.split('.');
						var _fchar = _array[_array.length - 2].substr(0, 1);
						
						if (_fchar == _fchar.toUpperCase()) {
							result = _array.splice(0, _array.length - 1).join('.');
						}
						
					}
					
					result = checkType(result);
					
					if (result == '?') result += '*';
					
					/*
					 * Only if xirsys_stdjs is being used
					 */
					if (Context.defined("xirsys_stdjs") && stdjs.match(result)) {
						var _array = result.split('.');
						result = _array[_array.length-1];
					}
					
					if (_p.length != 0) {
						
						result += '.<';
						
						for (param in _p) {
							if (param != _p[0]) result += ', ';
							result += buildRecordType(param);
						}
						
						result += '>';
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
					result = 'function(';
					
					for (arg in _a) {
						
						if (arg != _a[0]) {
							result += ',';
						}
						
						result += buildRecordType(arg.t);
						
						if (arg.opt) {
							result += '=';
						}
						
					}
					
					result += ')';
					if (_return != '') result += ':' + _return;
				
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
							var output = characters.google._typedef + ' {{';
							//var prevBuf = buf;
							var prevBuf = fragment;
							var prevTab = tabs;
							
							typedefs.set(result, true);
							
							createFile(def);
							tabs = 1;
							
							genPackage(def.pack);
							
							for (f in anon.fields) {
								if (f != anon.fields[0]) output += ', ';
								output += f.name + ':' + buildRecordType(f.type);
							}
							
							output += '}}';
							
							javaDoc.push(output);
							
							addJavaDoc(javaDoc);
							
							(def.pack.length == 0 ? print('var ') : '');
							
							(def.pack.length == 0 ?	print('$result', false) : print(result));
							newline(true);
							
							
							
							//buf = prevBuf;
							fragment = prevBuf;
							tabs = prevTab;
						}
						
					} else {
						var anon:AnonType = _a.get();
						result = '{';
						
						for (f in anon.fields) {
							if (f != anon.fields[0]) result += ', ';
							result += f.name + ':' + buildRecordType(f.type);
						}
						
						result += '}';
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
				case _:
					result = '';
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
		
		if (optional) _type += '=';
		
		return _type;
		
	}
	
	public function addFieldAnnotation(field:ClassField, ?overrides:Bool = false, ?self:String = "|"):Void {
		
		var javaDocs:Array<String> = new Array<String>();
		var fieldAccess:String = printAccess(field);
		var type:String;
		
		if (fieldAccess != '') javaDocs.push(printAccess(field));
		
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
							case _:
						}
					}
				}
			}
		}
		
		switch (field.kind) {
			case FMethod(_):
				
				if (overrides) {
					javaDocs.push( '@inheritDoc' );
				}
				
				switch (field.type) {
					
					case TFun(_args, _return):
						for (_arg in _args) {
							if (printType(_arg.t) == "*" && annotated.count() != 0) {
								type = "{" + annotated.get(_arg.name).join("|") + "}";
							} else {
								type = printType(_arg.t, _arg.opt);
							}
							if (type == self) type = "Object";
							javaDocs.push(characters.google._param + ' {$type} ${_arg.name}');
						}
						
						if (printType(_return) != '') {
							if (printType(_return) == "*" && annotated.count() != 0) {
								type = "{" + annotated.get("return").join("|") + "}";
							} else {
								type = printType(_return);
							}
							if (type == self) type = "Object";
							javaDocs.push(characters.google._return + ' {$type}');
						}
						
					case _:
				}
				
			case FVar(_read, _write):
				
				if (_read == VarAccess.AccInline && _write == VarAccess.AccNever) javaDocs.push(characters.google._const);
				javaDocs.push('@type {' + '?' + printType(field.type) + '}');
				
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
			javaDoc.push("@extends " + (superClass.pack.length > 0 ? superClass.pack.join('.') + '.' : '') + superClass.name);
		}
		
		if (_class.interfaces.length != 0) {
			for (inter in _class.interfaces) {
				javaDoc.push(characters.google._implements + ' ' + '{' + inter.t.get().module + '}');
			}
		}
		
		if (_class.constructor != null) {
			
			javaDoc.push( '@this {' + getPath( _class ) + '}' );
			
			switch (_class.constructor.get().type) {
				case TFun(_args, _):
					for (_arg in _args) {
						javaDoc.push(characters.google._param + ' ' + '{' + printType(_arg.t, _arg.opt) + '}' + ' ' + _arg.name);
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