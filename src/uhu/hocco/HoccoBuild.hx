package uhu.hocco;

import haxe.Http;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.Template;
import massive.neko.io.FileSys;
import massive.neko.util.PathUtil;
import sys.FileSystem;
import massive.neko.io.File;
import neko.Lib;

import Markdown;

using StringTools;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */

@:hocco
typedef TField = {
	var name:String;
	var pos:Position;
	var meta:MetaAccess;
	var doc:Null<String>;
	@:optional var isPublic:Bool;
}
 
@:hocco
typedef TSection = {
	var docs_text:String;
	var code_text:String;
	var id:Int;
}

@:hocco
typedef TDefaults = {
	@:optional var output_path:String;
	@:optional var lookup_files:Bool;
	@:optional var directory_path:String;
	@:optional var show_privates:Bool;
	@:optional var print_access:Bool;
	@:optional var print_metadata:Bool;
}

@:hocco
class HoccoBuild {
	
	/**
	 * Hocco is a [Haxe](http://haxe.org/) port of [Docco](http://jashkenas.github.com/docco/), the quick-and-dirty, 
	 * literate-programming-style documentation generator. It produces HTML that displays your comments alongside your code.  
	 * 
	 * Comments are passed through MDown, and code is passed through CodeHighlighter's syntax highlighting. 
	 * This page is the result of running Hocco against its own source file.
	 * 
	 * If you have Hocco in your `.hxml` file, you can use it as:
	 * 
	 * `@:hocco class MyClass`
	 * 
	 * In your `.hxml` file add `--macro Hocco.me()` which will generate linked HTML documentation for the class, 
	 * saving it into a `docs` folder by default.
	 * 
	 * Hocco is monolingual, but there are also [Docco](http://jashkenas.github.com/docco/), [Pycco](http://fitzgen.github.com/pycco/), 
	 * [Rocco](http://rtomayko.github.com/rocco/) and [Shocco](http://rtomayko.github.com/shocco/) written in and with support for other languages. 
	 * The [source for Hocco](https://github.com/skial/Hocco) is available on GitHub, and released under the MIT license.
	 * 
	 * To install Hocco, run `haxelib install Hocco` from the command line.
	 */
	public static var __reademe__:String;
	
	private static var ignore_me_Im_private:String;
	
	@:ignore
	public static function main() {
		Hocco;
		CodeHighlighter;
		/*new Something();
		new Foo();
		new Bar();
		new Hello();*/
	}
	
	/**
	 * ### Main Documentation Generation Function ###
	 * Generate the documentation for the source file by looping over every field in `field`, accessing its documentation field provided by the compiler,
	 * then reading the source code file, which then copies the related code, highlighting it and converts the markdown.
	 */
	public static function document(name:String, pos:Position, doc:Null<String>, fields:Array<TField>):Void {
		counter = 0;
		sections = new Array<TSection>();
		
		title = name;
		names.push(name);
		
		var code:String = File.create(Sys.getCwd() + Context.getPosInfos(pos).file).readString();
		
		if (doc != null) {
			sections.push( { docs_text:Markdown.markdownToHtml(parseComment(doc)), code_text:'', id:counter } );
			counter++;
		}
		
		for (f in fields) {
			if (isPrivate(f)) continue;
			if (hasIgnore(f)) continue;
			sections.push(parse(f, code.toString()));
			counter++;
		}
		
		names.sort(function(a, b) return Reflect.compare(a.toLowerCase(), b.toLowerCase()));
		
		generate_html();
	}
	
	/**
	 * Prepares Hocco for generating documentation for a Class by combining instance fields and static fields together. If the class has a constructor
	 * then it gets added to the `fields` array.
	 */
	public static function documentClass(local:ClassType):Void {
		var fields:Array<ClassField> = new Array<ClassField>();
		
		fields = local.fields.get().concat(local.statics.get());
		
		if (local.constructor != null) {
			fields.push(local.constructor.get());
		}
		
		document(local.name, local.pos, local.doc, cast fields);
		
	}
	
	/**
	 * Prepares Hocco for generating documentation for a [Typedef](http://haxe.org/manual/struct) by accessing the `TAnonymous` type's fields 
	 * which get passed along to document.
	 */
	public static function documentTypedef(local:DefType):Void {
		var fields:Array<ClassField> = new Array<ClassField>();
		
		switch (local.type) {
			case TAnonymous(f):
				fields = f.get().fields;
			case _:
		}
		
		document(local.name, local.pos, local.doc, cast fields);
	}
	
	/**
	 * Prepares Hocco for generating documentation for an [Enum](http://haxe.org/ref/enums) by storing all its constructs in `fields`.
	 */
	public static function documentEnum(local:EnumType):Void {
		var fields:Array<EnumField> = new Array<EnumField>();
		
		for (n in local.constructs.keys()) fields.push(local.constructs.get(n));
		
		document(local.name, local.pos, local.doc, cast fields);
	}
	
	/**
	 * Given the field and source code, remove unwanted formatting created by some IDE's and copy the source code using the information stored 
	 * in `field.pos`.
	 * 
	 * Pass the code to [CodeHighlighter](https://github.com/tong/codehighlighter) for syntax highlighting, pass the documentation to 
	 * [mdown](https://github.com/jasononeil/mdown) for markdown conversion.
	 * 
	 * Finally individual sections are created. Sections take the form:
	 * 
	 * 		{
	 * 			docs_text: ...
	 * 			code_text: ...
	 * 			id: ...
	 * 		}
	 */
	public static function parse(field:TField, src:String):TSection {
		var code = null;
		var doc = null;
		
		// Not perfect
		var align = new EReg('\t(};?</pre>)', '');
		var pos_info = Context.getPosInfos(field.pos);
		var doc_string = parseComment(field.doc);
		
		// Ugly code
		var code_string = if (!isReadMe(field)) {
			(print_metadata ? printMetadata(field) : '')
			+
			(print_access ? (field.isPublic ? 'public ' : 'private ') : '') 
			+
			src.substr(pos_info.min, (pos_info.max - pos_info.min)).replace('\t\t', '\t');
		} else {
			'';
		}
		
		if (lookup_files == true && doc_string == '') {
			var file = File.create(PathUtil.cleanUpPath(directory_path + local_file_path + File.seperator + field.name + '.md'), null, false);
			
			if (file.exists) {
				doc_string = file.readString();
			}
		}
		
		code = CodeHighlighter.highlight(code_string, 'haxe');
		
		if (align.match(code) && align.matchedRight().trim() == '') code = align.replace(code, '$1');
		
		doc = Markdown.markdownToHtml(doc_string);
		
		return { docs_text:doc, code_text:code, id:counter };
	}
	
	/**
	 * If you set `print_metadata` to true through `--macro Hocco.setDefaults( { print_access:true } )`, then any metadata associated
	 * with the current field being processed will be built and attached to the generated output.
	 */
	@:example(hello = 'world') 
	private static function printMetadata(field:TField):String {
		var result:String = '';
		var pos_info = null;
		var param:String = '';
		
		for (m in field.meta.get()) {
			pos_info = Context.getPosInfos(m.pos);
			
			result += '@' + m.name;
			
			for (p in m.params) {
				param = p.toString();
				result += (p != m.params[0] ? ', ' : '(');
				result += param.replace('(', '').replace(')', '');
			}
			
			result += (m.params.length != 0 ? ')' : '');
			result += '\n';
		}
		
		return result;
	}
	
	/**
	 * Once all the code and markdown have finished being processed, we can generate the HTML and write out the documentation.
	 */
	public static function generate_html():Void {
		File.create(output_path, null, true);
		
		file = File.create(output_path + 'hocco.css');
		file.writeString(File.create(raw_css).readString());
		
		file = File.create(output_path + 'jump_hocco.js');
		file.writeString('var jump_names = [' + function() { var a = ''; for (n in names) { a += '"' + n + '",'; } return a; } () + '];');
		
		file = File.create(output_path + title + '.html');
		var t = new Template(File.create(raw_html).readString());
		file.writeString(t.execute( { title:title, sections:sections, date:Date.now().toString() } ));
	}
	
	/**
	 * ### Helpers & Setup ###
	 * Hocco's current version.
	 */
	public static var VERSION:String = '2.0.1';
	
	/**
	 * Single file output used to create all the necessary files.
	 */
	public static var file:File;
	
	/**
	 * The title of the HTML file.
	 */
	public static var title:String;
	
	/**
	 * Used to hold all the individual sections.
	 */
	public static var sections:Array<TSection>;
	
	/**
	 * Used to hold all the names of each HTML file created.
	 */
	public static var names:Array<String> = new Array<String>();
	
	/**
	 * Used for template generation.
	 */
	public static var counter:Int = 0;
	
	/**
	 * Used to determine if private fields should be generated.
	 */
	public static var show_privates:Bool = false;
	
	/**
	 * Used to determine if the field access should be included in the documentation.
	 */
	public static var print_access:Bool = true;
	
	/**
	 * Used to tell hocco to print out any metadata the field might have.
	 */
	public static var print_metadata:Bool = false;
	
	/**
	 * Used to determine if hocco should look in `directory_path` for non inline documentation.
	 */
	public static var lookup_files:Bool = false;
	
	/**
	 * Used to determine where hocco should look when `lookup_files` is true, for the current class, typedef or enum being processed.
	 */
	public static var local_file_path:String = '';
	
	/**
	 * The base directory hocco will start looking from.
	 */
	public static var directory_path:String = Sys.getCwd();
	
	/**
	 * The output directory hocco will write everything to. Useful when building documentation for multiple projects, so it does get mixed together.
	 */
	public static var output_path:String = Sys.getCwd() + File.seperator + 'docs' + File.seperator;
	
	/**
	 * The location of `hocco.css`.
	 */
	//public static var raw_css:String = Sys.getCwd() + File.seperator + Context.resolvePath('uhu/hocco/assets/hocco.css');
	public static var raw_css:String = Sys.getCwd() + File.seperator + FileSystem.fullPath('uhu/hocco/assets/hocco.css');
	
	/**
	 * The location of `hocco.html` template.
	 */
	public static var raw_html:String = Sys.getCwd() + File.seperator + Context.resolvePath('uhu/hocco/assets/hocco.html');
	
	/**
	 * Checks if `field` is private.
	 */
	public static function isPrivate(field:TField):Bool {
		if (show_privates) {
			return false;
		} else {
			return !field.isPublic;
		}
	}
	
	/**
	 * Checks if `field` has the `@:ignore` or `@ignore` meta tag.
	 */
	public static function hasIgnore(field:TField):Bool {
		if (field.meta.has(':ignore') || field.meta.has('ignore')) return true;
		return false;
	}
	
	/**
	 * This is a work around for [Issue 1](https://github.com/skial/Hocco/issues/1)
	 */
	public static function isReadMe(field:TField):Bool {
		if (field.name == '__reademe__') return true else return false;
	}
	
	/**
	 * Takes a `String` and replaces common IDE specific comment formating.
	 */
	public static function parseComment(doc:Null<String>):String {
		return doc == null ? '' : doc.replace('\n\t * ', '').replace('/**', '');
	}
	
}