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
			
		} else {
			switch( f.kind ) {
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
				case _:
					genStaticValue(c, f);
			}
			
		}
		
		//genExpose( { name:p + field, meta:f.meta } );
		
		//newline();
		
	}
	
	public function checkMeta(b:{ name:String, meta:MetaAccess }) {
		
		for (meta in b.meta.get()) {
			
			switch (meta.name) {
				
				case ':expose':
					generateExpose( b );
				case _:
				
			}
			
		}
		
	}
	
	public var has__iterator__:Bool = false;
	public var has__bind__:Bool = false;
	
	public function checkSpecials(c:ClassType, f:ClassField) {
		
		switch (f.name) {
			case 'iterator':
				has__iterator__ = true;
				has__bind__ = true;
			case 'bind':
				has__bind__ = true;
			case _:
				
		}
		
		switch ( getPath( c ) + '.' + f.name ) {
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
	function generateExpose(t: { name:String, meta:MetaAccess } ) {
		
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
		//print('$$hxClasses["$p"] = $p');
		fragment.parts.push( function() {
			var out = '';
			
			if (has__hxClasses__) {
				
				out += '$$hxClasses["$p"] = $p;\n';
				
			}
			
			return out;
		} );
		
		//newline(true, 1);
		
		for (f in c.statics.get()) {
			genStaticField(c, p, f);
		}
		
		var name = getPath(c).split('.').map(api.quoteString).join(',');
		
		/*addJavaDoc(["@type {Array.<string>}"]);
		print('$p.__name__ = [$name]');
		newline(true);*/
		fragment.parts.push( function() {
			var out = '';
			
			if (has__className__) {
				
				out += "@type {Array.<string>}\n";
				out += '$p.__name__ = [$name];\n';
				
			}
			
			return out;
		} );
		
		if (c.interfaces.length > 0) {
			
			var me = this;
			var inter = c.interfaces.map(
				function(i) { 
					return me.getPath( i.t.get() );
				}
			).join(',');
			
			/*print('$p.__interfaces__ = [$inter]');
			newline(true);*/
			fragment.parts.push( function() {
				var out = '';
				
				if (has__interfaces__) {
					
					out += '$p.__interfaces__ = [$inter];\n';
					
				}
				
				return out;
			} );
			
		}
		
		if(c.superClass != null) {
			var psup = getPath(c.superClass.t.get());
			
			/*print('$p.__super__ = $psup');
			newline(true);
			
			print('$p.prototype = $$extend($psup.prototype, { ');*/
			fragment.parts.push( function() {
				var out = '';
				
				if (has__superClass__) {
					
					out += '$p.__super__ = $psup;\n';
					
					if (c.fields.get().length != 0) {
						out += '$p.prototype = $$etend($psup.prototype, {\n';
					}
					
				}
				
				return out;
			} );
		} else {
			//print('$p.prototype = {');
			if (c.fields.get().length > 0) {
				fragment.parts.push( function() return '$p.prototype = {\n' );
			}
		}
		
		/*tabs++;
		newline();
		
		print('__class__:$p');*/
		fragment.parts.push( function() {
			var out = '';
			
			if (has__class__) {
				
				tabs++;
				
				if (c.fields.get().length == 0) {
					out += '$p.prototype.__class__:$p\n';
				} else {
					out += '\t__class__:$p';
				}
				
			}
			
			return out;
		} );
		
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
		
		if (c.fields.get().length != 0) {
			
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
					
					addJavaDoc(['@type {$p}']);
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
				
				if(c.init != null) {
					inits.add(c.init);
				}
				
				if (!c.isExtern) {
					genClass(c);
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
		
		var entryFragment = fragment;
		
		if (Context.defined("js_modern")) {
			print(" 'use strict';");
		}
		
		newline();
		newline();
		
		if (has__hxClasses__) {
			addJavaDoc(["@type {Object.<string, *>}"]);
		}
		
		fragment.parts.push( function() {
			var out = '';
			
			if (has__hxClasses__) {
				
				out += "var $hxClasses = {}\n";
				
			}
			
			return out;
		} );
		
		fragment.parts.push( function() {
			var out = '';
			
			if (hasEnum) {
				
				out += '/** ${characters.google._return} {string} */\n';
				out += "function $estr() {\n";
				out += "\treturn js.Boot.__string_rec(this, '');\n";
				out += "}\n";
				
			}
			
			return out;
		} );
		
		newline();
		
		fragment.parts.push( function() {
			var out = '';
			
			if (has__bind__) {
				out += '/** @type {*} */\n';
				out += "var '$_ = {};\n";
				// add google closure annotations
				out += "function $bind(o,m) {\n";
				out += "\tvar f = function(){\n";
				out += "\t\treturn f.method.apply(f.scope, arguments);\n";
				out += "\t};\n";
				out += "\tf.scope = o;\n";
				out += "\tf.method = m;\n";
				out += "\treturn f;\n";
				out += "}\n";
			}
			
			return out;
		} );
		
		fragment.parts.push( function() {
			var out = '';
			
			if (has__iterator__) {
				// add google closure annotations
				out += "function $iterator(o) {\n";
				out += "\tif(o instanceof Array) return function() { return HxOverrides.iter(o); };\n";
				out += "\treturn typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator;\n";
				out += "}\n";
			}
			
			return out;
		} );
		
		for(t in api.types) {
			genType(t);
		}
		
		newline();
		
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
		
		var initFragment:TBuffered = { name:'DelkoInits', parts:[] };
		bufA.push( initFragment );
		fragment = initFragment;
		
		/**
		 * Generate code for all __init__ methods
		 */
		if (inits.length > 0) {
			for (e in inits) {
				
				addJavaDoc( [ '@this {?}' ] );
				var string = api.generateStatement(e);
				string = string.replace('\n', '\n' + repeat('\t', tabs));
				print(string);
				newline( (string.trim().endsWith("}") ? false : true), 1);
				
			}
		}
		
		fragment = entryFragment;
		
		var sep = massive.neko.io.File.seperator;
		var dir = massive.neko.io.File.create(FileSystem.fullPath(api.outputFile));
		var uhu = massive.neko.io.File.create(PathUtil.cleanUpPath(dir.parent.nativePath + sep + "fragments"), null, true);
		var file = null;
		
		/**
		 * Loop through the string buffer array, write the content of each to a file.
		 * Replace all occurances of .$bind with ["$bind"]. Prevents google closure compiler
		 * from tripping as Boot.hx sets it as Function.prototype["$bind"].
		 */
		for (f in bufA) {
			var out = '';
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
		fragment.parts.push( function() {
			return (tab ? repeat('\t', tabs) : '') + str;
		} );
	}
	
	public function newline(?semicolon:Bool = false, ?extra:Int = 0) {
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
	
	public function addJavaDoc(parts:Array<String>) {
		var out = '';
		
		if (parts.length > 0) {
			out += '/**\n';
		}
		
		for (p in parts) {
			
			out += ' * $p\n';
			
		}
		
		if (parts.length > 0) {
			out += ' */\n';
			fragment.parts.push( function() return out );
		}
		
	}
	
	public function addFieldAnnotation(field:ClassField, ?overrides:Bool = false, ?self:String = "|"):Void {
		var parts = [];
		
		if (field.doc != null) {
			parts.push( field.doc.trim() );
		}
			
		if (!field.isPublic) {
			parts.push( '@private' );
		}
			
		switch (field.kind) {
			case FVar(r, w):
				
				if (r == VarAccess.AccInline && w == VarAccess.AccNever) {
					parts.push( '@const' );
				}
				
				parts.push( '@type {?' + field.type.getName() + '}' );
				
			case FMethod(k):
				
				if (overrides) {
					parts.push( '@inheritDoc' );
				}
				
				switch ( Context.getTypedExpr( field.expr() ).expr ) {
					case EFunction(n, m):
						
						for (a in m.args) {
							parts.push( '@param {' + a.type.toString() + (a.opt ? '=' : '') + '} ' + a.name );
						}
						
						if (m.ret != null) {
							parts.push( '@return {' + m.ret.toString() + '}' );
						}
						
					case _:
						
				}
		}
		
		addJavaDoc( parts );
		
	}
	
	public function addClassAnnotation(c:ClassType):Void {
		var parts = [];
		
		if (c.constructor != null) {
			
			if (c.constructor.get().doc != null) {
				parts.push( '${c.constructor.get().doc}' );
			}
			
			switch ( Context.getTypedExpr( c.constructor.get().expr() ).expr ) {
				case EFunction(n, m):
					
					for (a in m.args) {
						parts.push( '@param {' + a.type.toString() + (a.opt ? '=' : '') + '} ' + a.name );
					}
					
				case _:
					
			}
			
		}
		
		if (c.isInterface) {
			parts.push( '@interface' );
		} else {
			parts.push( '@constructor' );
		}
		
		if (c.superClass != null) {
			parts.push( '@extends {' + getPath( c.superClass.t.get() ) + '}' );
		}
		
		if (c.interfaces.length > 0) {
			for (i in c.interfaces) {
				parts.push( '@implements {' + getPath( i.t.get() ) + '}' );
			}
		}
		
		addJavaDoc( parts );
		
	}
	
	#if macro
	public static function use() {
		Compiler.setCustomJSGenerator(function(api) new Delko(api).generate());
	}
	#end
	
}