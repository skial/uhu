package uhu.js;

import haxe.macro.Tools;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.JSGenApi;
import haxe.macro.Compiler;
import haxe.macro.ExampleJSGenerator;
import neko.FileSystem;

import massive.neko.io.FileSys;
import massive.neko.util.PathUtil;

import sys.io.File;
import sys.io.FileOutput;

import tink.macro.tools.ExprTools;
import tink.macro.tools.MacroTools;
import tink.macro.tools.Printer;
import tink.macro.tools.TypeTools;
import tink.core.types.Outcome;
import tink.core.types.Option;

using Lambda;
using StringTools;
using tink.macro.tools.MacroTools;
using tink.core.types.Outcome;
using tink.core.types.Option;

/**
 * ...
 * @author Skial Bainn (http://blog.skialbainn.com)
 */

/**
 * TODO
 * -----
 * 		Some odd code still lingers... fix it b!^#h
 * 		Add .sh files on osx and linux - play nice
 * 19/06/2012
 * -----
 * 		removed pause from generated .bat files.
 * 18th June 2012
 * -----
 * 		cleanup code. to much commented code around.
 * 		write more documentation, the most fun still awaits.
 * 
 * 		removed buildTypeInfo method
 * 		removed buildClosureTypedef method
 * 		removed getTypePath method - can find it in uhu.Library
 * 		removed buildJSTypedef method - part of buildRecordType method
 * 
 * 		fixed google closure compiler output wrapper problem. In batch files, windows cmd tries
 * 		to expand %output% to a existing variable, but removes it if it fails. Fix can be found at
 * 		https://groups.google.com/d/msg/closure-compiler-discuss/I71qjX1HXKY/l78ApDVeY5MJ
 * 
 * 		added @:exportProperties meta detection & support. At the moment it turns static fields
 * 		to org.haxe['Name'] = function() {} instead of org.haxe.Name = function() {}. This
 * 		stops google closure compiler from renaming 'Name' to 'a' for example
 * unknown date, whats git?
 * -----
 * 		added createFile method
 * 		added bufA which is an array of objects { b:StringBuf, n:String } - n is the name of the class, enum or typedef
 * 11th June 2012
 * -----
 * 		added bufA
 * 		added createFile
 * 11th May 2012
 * -----
 * 		added genExpose
 * 		static fields can now be :exposed to match offical haxe output
 * 
 * 8th May 2012
 * -----
 * 		added the following compiler flags and neccasary checks, which *will* break some standard library methods (Reflect), use with care.
 * 		uhu_remove_class_name	eg: MyClass.__name__=['MyClass']
 * 		uhu_remove_class_super	eg: MyClass.__super__=MySuperClass
 * 		uhu_remove_class_interfaces	eg: MyClass.__interfaces__=[Inter1,Inter2]
 * 		uhu_remove_class_ref	eg: __class__:MyClass
 */

class Uhu  {

	var api : JSGenApi;
	var buf : StringBuf;
	//var bufA:Array<{n:String, b:StringBuf}>;
	var bufA:Hash<StringBuf>;
	var inits : List<TypedExpr>;
	var statics : List<{ c : ClassType, f : ClassField }>;
	var packages : Hash<Bool>;
	var typedefs : Hash<Bool>;
	var forbidden : Hash<Bool>;

	public function new(api) {
		this.api = api;
		tabs = 0;
		buf = new StringBuf();
		
		/**
		 * Create the array which will hold all the generated javascript
		 */
		//bufA = new Array<{n:String, b:StringBuf}>();
		bufA = new Hash<StringBuf>();
		
		/**
		 * Add the first string buffer
		 */
		//bufA.push( { n:'UhuEntry', b:buf } );
		bufA.set('UhuEntry', buf);
		inits = new List();
		statics = new List();
		packages = new Hash();
		typedefs = new Hash();
		forbidden = new Hash();
		
		for ( x in ["prototype", "__proto__", "constructor"] ) {
			forbidden.set(x, true);
		}
		
		api.setTypeAccessor(getType);
	}

	function getType( t : Type ) {
		return switch(t) {
			case TInst(c, _): getPath(c.get());
			case TEnum(e, _): getPath(e.get());
			default: throw "assert";
		};
	}
	
	function createFile(c:BaseType):Void {
		buf = new StringBuf();
		//bufA.push({n:getPath(c), b:buf});
		bufA.set(getPath(c), buf);
	}

	function field(p) {
		return api.isKeyword(p) ? '["' + p + '"]' : "." + p;
	}
	
	function genPackage( p : Array<String> ) {
		var full = null;
		
		for( x in p ) {
			var prev = full;
			
			if( full == null ) full = x else full += "." + x;
			if( packages.exists(full) ) continue;
			packages.set(full, true);
			
			addJavaDoc(['@type {Object}']);
			
			if( prev == null )
				fprint('var $x = {}');
			else {
				var p = prev + field(x);
				fprint('$p = {}');
			}
			
			newline();
		}
		
	}
	
	public static var dot:String = '.';
	
	function getPath( t : BaseType ) {
		//var result = (t.pack.length == 0) ? t.name : t.pack.join(dot) + dot + t.name;
		var result = (t.pack.length == 0) ? t.name : t.pack.concat([t.name]).join(dot);
		return result != null ? '' : result;
		//return (t.pack.length == 0) ? t.name : t.pack.concat([t.name]).join(dot);
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
		
		fprint("${f.name}:");
		
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
			if (c.meta.has(':exportProperties')) {
				fprint('$p["${f.name}"] = null');
			} else {
				fprint("$p$field = null");
			}
			
			newline(true);
			
		} else switch( f.kind ) {
			case FMethod(_):
				
				/**
				 * If the class has the neta tag @:exportProperties, then all fields
				 * become Class["field"] = {}.
				 */
				if (c.meta.has(':exportProperties')) {
					fprint('$p["${f.name}"] = ');
				} else {
					fprint("$p$field = ");
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
		
		if (t.meta.has(':expose')) {
			fprint('$$hxExpose(${t.name}, ');
			
			for (m in t.meta.get()) {
				if (m.name == ':expose') {
					if (m.params.length != 0) {
						print(''+ExprTools.toString(m.params[0]), false);
					} else {
						fprint('${t.name}', false);
					}
				}
			}
			
			print(')', false);
			
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
		
		print(c.pack.length == 0 ? 'var ' : '');
		
		fprint('$p = ', false);
		
		if ( c.constructor != null ) {
			genExpr(c.constructor.get().expr(), false);
		} else {
			print("function() {}", false);
		}
		
		newline();
		
		genExpose( { name:p, meta:c.meta } );
		
		fprint("$$hxClasses['$p'] = $p");
		
		newline(true, 1);
		
		for ( f in c.statics.get() ) {
			genStaticField(c, p, f);
		}
		
		var name = getPath(c).split('.').map(api.quoteString).join(',');
		
		addJavaDoc(['@type {Array.<string>}']);
		fprint("$p.__name__ = [$name]");
		newline(true);
		
		if( c.interfaces.length > 0 ) {
			var me = this;
			var inter = c.interfaces.map(function(i) return me.getPath(i.t.get())).join(",");
			
			fprint("$p.__interfaces__ = [$inter]");
			newline(true);
		}
		
		if( c.superClass != null ) {
			var psup = getPath(c.superClass.t.get());
			
			fprint("$p.__super__ = $psup");
			newline(true);
			
			fprint('$p.prototype = $$extend($psup.prototype, { ');
		} else {
			fprint('$p.prototype = { ');
		}
		
		tabs++;
		newline();
		
		fprint('__class__:$p');
		
		var i:Int = 0;
		
		for ( f in c.fields.get() ) {
			
			switch( f.kind ) {
				case FVar(r, _):
					if( r == AccResolve ) continue;
				default:
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

	function genEnum( e : EnumType ) {
		var p = getPath(e);
		var names = p.split(".").map(api.quoteString).join(",");
		var constructs = e.names.map(api.quoteString).join(",");
		var meta = api.buildMetaData(e);
		
		createFile(e);
		
		newline(false, 1);
		genPackage(e.pack);
		
		addJavaDoc(['@type {{__ename__:Array.<string>, __constructs__:Array.<string>}}']);
		print(e.pack.length == 0 ? 'var ' : '');
		fprint("$p = { __ename__ : [$names], __constructs__ : [$constructs] }", false);
		newline();
		fprint("$$hxClasses['$p'] = $p");
		newline(true);
		
		for( c in e.constructs.keys() ) {
			var c = e.constructs.get(c);
			var f = field(c.name);
			
			switch( c.type ) {
				case TFun(args, _):
					fprint("$p$f = ");
					var sargs = args.map(function(a) return a.name).join(",");
					fprint('function($sargs) { var $$x = ["${c.name}",${c.index},$sargs]; $$x.__enum__ = $p; $$x.toString = $$estr; return $$x; }', false);
					newline();
				default:
					addJavaDoc(['@type {Array.<(string|number)>}']);
					fprint("$p$f = ");
					print("[" + api.quoteString(c.name) + "," + c.index + "]", false);
					newline(true);
					
					addJavaDoc(['@return {string}']);
					fprint("$p$f.toString = $$estr");
					newline(true);
					
					addJavaDoc(['@type {' + p + '}']);
					fprint("$p$f.__enum__ = $p");
					newline(true);
			}
			
		}
		
		if( meta != null ) {
			fprint("$p.__meta__ = ");
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
		if (c.meta.has(':exportProperties')) {
			fprint('$p["${cf.name}"] = ');
		} else {
			fprint("$p$f = ");
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
				if( !c.isExtern ) genClass(c);
			case TEnum(r, _):
				var e = r.get();
				if( !e.isExtern ) genEnum(e);
			default:
		}
	}

	public function generate() {
		
		if (Context.defined('js_modern')) {
			print (' "use strict";');
		}
		
		newline();
		
		tabs++;
		newline();
		
		addJavaDoc(['@type {*}']);
		print('var $_ = {}');
		newline(true, 1);
		
		addJavaDoc(['@type {Object.<string, *>}']);
		print('var $hxClasses = {}');
		newline(true, 1);
		
		addJavaDoc(['@return {string}']);
		printParts(['function $estr() {', '\treturn js.Boot.__string_rec(this, "");', '}']);
		
		newline();
		
		addJavaDoc(['@param {Object} from', '@param {Object.<string, Object>} fields']);
		printParts(['function $extend(from, fields) {', '\t/** @constructor */', '\tfunction inherit() {};', '\tinherit.prototype = from;', 
		'\tvar proto = new inherit();', '\tfor (var name in fields) proto[name] = fields[name];', '\treturn proto;', '}']);
		
		newline();
		
		addJavaDoc(['@param {Object} src', '@param {string} path']);
		printParts(['function $hxExpose(src, path) {', '\t/** @type {Window} */', '\tvar o = window;', 
		'\t/** @type {Array.<string>} */', '\tvar parts = path.split(".");', '\tfor (var ii = 0; ii < parts.length-1; ++ii) {', 
		'\t\tvar p = parts[ii];', '\t\tif(typeof o[p] == "undefined") o[p] = {};', '\t\to = o[p];', '\t}', '\to[parts[parts.length-1]] = src;', '}']);
		
		for( t in api.types ) {
			genType(t);
		}
		
		newline();
		addJavaDoc(['@type {*}']);
		print("js.Boot.__res = {}");
		newline();
		print("js.Boot.__init()");
		newline(true);
		
		/**
		 * Generate code for all __init__ methods
		 */
		for( e in inits ) {
			print(api.generateStatement(e).replace('\n', '\n' + repeat('\t', tabs)));
			newline();
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
		
		var sep = massive.neko.io.File.seperator;
		var dir = massive.neko.io.File.create(FileSystem.fullPath(api.outputFile));
		var uhu = massive.neko.io.File.create(PathUtil.cleanUpPath(dir.parent.nativePath + sep + '_uhu_'), null, true);
		
		/**
		 * Loop through the string buffer array, write the content of each to a file.
		 * Replace all occurances of .$bind with ["$bind"]. Prevents google closure compiler
		 * from tripping as Boot.hx sets it as Function.prototype["$bind"].
		 */
		//for (f in bufA) {
		for (f in bufA.keys()) {
			var file = neko.io.File.write(uhu.nativePath + sep + f + '.js', true);
			file.writeString(bufA.get(f).toString().replace('.$bind', '["$bind"]'));
			file.close();
		}
		
		/**
		 * Create three .bat files, which allow you to run 
		 * google closure compiler in each compression level. 
		 * 
		 * Im so thoughtful :D
		 */
		for (op in ['WHITESPACE_ONLY', 'SIMPLE_OPTIMIZATIONS', 'ADVANCED_OPTIMIZATIONS']) {
			var file = neko.io.File.write(dir.parent.nativePath + sep + Std.format('closure_compiler_${op.toLowerCase()}.bat'), true);
			file.writeString(Std.format('java -jar compiler.jar --output_wrapper "(function(context) {%%output%%})(window);" ${if(Context.defined("debug")){"--formatting=pretty_print";}else{"";}} --create_source_map=./${dir.fileName}.map --compilation_level ${op} --js_output_file ${dir.fileName} '));
			for (f in bufA.keys()) {
				//file.writeString(Std.format('--js .${sep}_uhu_${sep}${f}.js '));
				file.writeString('--js .' + sep + '_uhu_' + sep + f + '.js ');
			}
			file.close();
		}
		
	}
	
	/**
	 * -------------------------
	 * UHU METHODS AND VARIABLES
	 * -------------------------
	 */ 
	
	public var tabs:Int;
	
	public inline function genExpr(e, ?tab:Bool = true) {
		var _str:String = api.generateValue(e).replace('\n', '\n' + repeat('\t', tabs));
		print(_str, tab);
	}
	
	@:macro	public static function fprint(e:Expr , ?tab:Bool = true) {
		var pos = haxe.macro.Context.currentPos();
		var ret = haxe.macro.Format.format(e);
		var boo = Context.parse('' + tab, pos);
		return { expr : ECall({ expr : EConst(CIdent("print")), pos : pos },[ret, boo]), pos : pos };
	}
	
	public inline function print(str:String, ?tab:Bool = true) {
		buf.add((tab ? repeat('\t', tabs) : '') + str);
	}
	
	public inline function newline(?semicolon:Bool = false, ?extra:Int = 0) {
		buf.add((semicolon ? ';' : '') + '\n' + repeat('\n', extra));
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
			print('/**');
			if (comments.length != 1) newline();
			for (comment in comments) {
				if (comments.indexOf(comment) == i) {
					if (comments.length != 1) {
						fprint('* $comment');
						newline();
					} else {
						fprint(' $comment ', false);
					}
				}
				i++;
			}
			print('*/', comments.length == 1 ? false : true);
			newline();
		}
	}
	
	public function printAccess(field:{isPublic:Bool}):String {
		return field.isPublic ? '' : '@private';
	}
	
	/**
	 * Checks the type for a google closure compiler
	 * annotations match and returns it.
	 */
	public function checkType(type:String):String {
		
		return switch (type) {
			case 'Dynamic':
				'Object';
			case 'Int', 'Float':
				'number';
			case 'Bool':
				'boolean';
			case 'String':
				'string';
			case 'null', null:
				'*';
			case 'Null':
				'?';
			case 'Void':
				'';
			default:
				type;
		}
	}
	
	/**
	 * UHU GOD!
	 */
	public function buildRecordType(type:Type, ?data: { parent:BaseType, params:Array<Type> }):String {
		
		switch(type) {
			/**
			 * If not null, then send back through buildRecordType and return
			 */
			case TMono(_t):
				var mono = _t.get();
				if (mono != null) {
					return buildRecordType(mono);
				} else {
					return checkType('' + mono);
				}
			
			/**
			 * Build value. If it has params, then output jsdoc style type application
			 * e.g Array.<string> or Object.<string, number>
			 */
			case TEnum(_t, _p):
				var enm:EnumType = _t.get();
				
				if (enm.name.length == 0) return '';
				
				var path = checkType(getPath(enm));
				if (_p.length != 0) {
					path += '.<';
					for (param in _p) {
						if (param != _p[0]) path += ', ';
						path += buildRecordType(param);
					}
					path += '>';
				}
				return path;
			
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
				
				if (cls.name.length == 0) return '';
				
				var path = getPath(cls);
				
				/*
				 * Should detect things like indexOf.T, or indexOf.TA
				 * or indexOf.TAADSDSDS
				 */ 
				var typedParam:EReg = ~/\.[A-Z]+$/;
				
				/*
				 * Should detect most? of xirsys_stdjs
				 */
				var stdjs:EReg = ~/^js\.(w3c|webgl)\./i;
				
				if (typedParam.match(path)) {
					/**
					 * Only remove the last value if its first character
					 * is not lowercase - this means it a package name.
					 * Class names in most cases start with Uppercase
					 * character. Poor mans check...
					 */
					var _array = path.split('.');
					var _fchar = _array[_array.length - 2].substr(0, 1);
					
					if (_fchar == _fchar.toUpperCase()) {
						path = _array.splice(0, _array.length - 1).join('.');
					}
					
				}
				
				path = checkType(path);
				
				if (path == '?') path += '*';
				
				/*
				 * Only if xirsys_stdjs is being used
				 */
				if (Context.defined('xirsys_stdjs') && stdjs.match(path)) {
					var _array = path.split('.');
					path = _array[_array.length-1];
				}
				
				if (_p.length != 0) {
					path += '.<';
					for (param in _p) {
						if (param != _p[0]) path += ', ';
						path += buildRecordType(param);
					}
					path += '>';
				}
				
				return path;
				
			/**
			 * Pass typedef back through buildRecordType and return
			 */
			case TType(_t, _p):
				var _def = buildRecordType(_t.get().type, { parent:cast _t.get(), params:_p } );
				return _def;
			
			/**
			 * Build jsdoc function definition, usually used for param/typedef sigs
			 */
			case TFun(_a, _r):
				var _return = buildRecordType(_r);
				var _output = 'function(';
				for (arg in _a) {
					if (arg != _a[0]) _output += ',';
					_output += buildRecordType(arg.t);
					if (arg.opt) _output += '=';
				}
				_output += ')';
				if (_return != '') _output += ':' + _return;
				return _output;
			
			/**
			 * Usually builds typedefs, which is why TAnonymous builds two different outputs,
			 * a google closure compiler typedef and a truely anonymous sig.
			 */
			case TAnonymous(_a):
				if (data != null) {
					var def:BaseType = data.parent;
					if (def.name.length == 0) return '';
					var path:String = checkType(getPath(def));
					var anon:AnonType = _a.get();
					
					if (!typedefs.exists(path) && anon.fields.length != 0) {
						var javaDoc = new Array<String>();
						var output = '@typedef {{';
						var prevBuf = buf;
						var prevTab = tabs;
						
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
						
						(def.pack.length == 0 ?	fprint('$path', false) : fprint('$path'));
						newline(true);
						
						typedefs.set(path, true);
						
						buf = prevBuf;
						tabs = prevTab;
					}
					
					return path;
				} else {
					var anon:AnonType = _a.get();
					var output = '{';
					for (f in anon.fields) {
						if (f != anon.fields[0]) output += ', ';
						//output += Std.format('${f.name}:${buildRecordType(f.type)}');
						output += f.name + ':' + buildRecordType(f.type);
					}
					output += '}';
					return output;
				}
				return 'TAnonymous';
			
			/**
			 * If not null, send back through buildRecordType and return
			 */
			case TDynamic(_t):
				if (_t != null) {
					trace(buildRecordType(_t));
					return buildRecordType(_t);
				} else {
					return checkType(''+_t);
				}
				
			/**
			 * Havnt done this yet...
			 */
			case TLazy(_f):
				return 'TLazy';
			default:
				return '';
		}
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
	
	public function addFieldAnnotation(field:ClassField, ?self:String = '|'):Void {
		
		var javaDocs:Array<String> = new Array<String>();
		var fieldAccess:String = printAccess(field);
		var type:String;
		
		if (fieldAccess != '') javaDocs.push(printAccess(field));
		
		switch (field.kind) {
			case FMethod(k):
				
				switch (field.type) {
					
					case TFun(_args, _return):
						for (_arg in _args) {
							type = printType(_arg.t, _arg.opt);
							if (type == self) type = 'Object';
							javaDocs.push ('@param {' + type + '} ' + _arg.name);
						}
						
						if (printType(_return) != '') {
							type = printType(_return);
							if (type == self) type = 'Object';
							javaDocs.push('@return {' + type + '}');
						}
						
					default:
				}
				
			case FVar(_read, _write):
				
				if (_read == VarAccess.AccInline && _write == VarAccess.AccNever) javaDocs.push('@const');
				javaDocs.push('@type {?' + printType(field.type) + '}');
				
			default:
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
		 * but outputs a boat load more warning, mainly about the dangerous use of 'this'.
		 * 
		 * Before switching to just @const, I only had 8 warnings about the use of 'this' 
		 * as a possible bug. With just @const I have 158 warnings. :)
		 * 
		 * Code will be kept commented out.
		 */
		/*if (!_class.isInterface && _class.constructor != null) javaDoc.push('@const');//javaDoc.push('@constructor');
		
		if (_class.constructor == null && _class.interfaces.length == 0) {
			javaDoc.push('@const');
		} else {
			//javaDoc.push('@constructor');
			javaDoc.push('@const');
		}*/
		javaDoc.push('@const');
		
		if (_class.isInterface) javaDoc.push('@interface');
		
		if (_class.superClass != null) {
			superClass = _class.superClass.t.get();
			javaDoc.push('@extends ' + (superClass.pack.length > 0 ? superClass.pack.join('.') + '.' : '') + superClass.name);
		}
		
		if (_class.interfaces.length != 0) {
			for (inter in _class.interfaces) {
				javaDoc.push('@implements {' + inter.t.get().module + '}');
			}
		}
		
		if (_class.constructor != null) {
			switch (_class.constructor.get().type) {
				case TFun(_args, _return):
					for (_arg in _args) {
						javaDoc.push('@param {' + printType(_arg.t, _arg.opt) + '} ' + _arg.name);
					}
				default:
			}
		}
		
		addJavaDoc(javaDoc);
		
	}
	
	#if macro
	public static function use() {
		Compiler.setCustomJSGenerator(function(api) new Uhu(api).generate());
	}
	#end
	
}