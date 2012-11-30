package ;

import Type in StdType;

#if macro
import dtx.XMLWrapper;
import haxe.macro.Expr;
import massive.neko.util.PathUtil;
import sys.FileSystem;
import sys.io.File;
import uhu.tem.Binder;
import uhu.tem.Scope;
import uhu.tem.Common;
import uhu.tem.Validator;
import haxe.macro.Type;
import uhu.macro.Du;
import uhu.macro.Jumla;
import haxe.macro.Context;
import haxe.macro.Compiler;
using uhu.Library;
#end

using StringTools;
using Lambda;

/**
 * ...
 * @author Skial Bainn
 */

/*
 * Might rename to Albert because he was awesome
 * Vezati is "bind" in Croatian
 */
@:keep class Tem {
	
	#if !macro
	public static function main() {
		//Tem.setClasses(['MyClass1', 'MyClass2', 'Class1', 'YourClass']);
		Tem.compile('templates/vezati/basic.vezati.html');
	}
	#end
	
	@:macro public static function setClasses(classes:Array<String>) {
		
		/*switch (classes.expr) {
			case EArrayDecl(values):
				
				for (v in values) {
					
					switch (v.expr) {
						case EConst(c):
							var s:String = Jumla.constValue(c);
							var t = Jumla.getClass( s );
							var p = t.cls.pack.join('.');
							var m = t.cls.module;
							var r = { name:(p == '' ? p + m + '.' : p + '.') + t.cls.name, cls:t.cls, params:t.params };
							//t.cls.meta.add(':build(uhu.tem.Binder.build())', [], t.cls.pos);
							//t.cls.meta.add('@:build', [Context.parseInlineString('uhu.tem.Binder.build()', t.cls.pos)], t.cls.pos);
							Compiler.addMetadata('@:build(uhu.tem.Binder.build())', r.name);
							Compiler.keep(r.name, null, true);
							trace(t.cls.meta.get());
							//trace(Context.toComplexType(Context.getType(s)));
							Common.classes.set(s, r);
						default:
					}
					
				}
				
			default:
		}*/
		
		for (path in Context.getClassPath()) {
			
			if (path != '') {
				
				if ( PathUtil.isAbsolutePath(path) ) {
					
					path = PathUtil.cleanUpPath( path );
					
				} else if ( PathUtil.isRelativePath(path) ) {
					
					if (path.startsWith('..')) path = path.substr(2);
					path = PathUtil.cleanUpPath( FileSystem.fullPath(path) );
					
				}
				
				var files:Array<MFile> = MFile.create(path).getRecursiveDirectoryListing(~/.hx/);
				
				for (file in files) {
					
					try {
						var cls = StdType.resolveClass(file.name);
						if (cls != null) {
							trace( StdType.getClassName( cls ) );
							trace( StdType.getInstanceFields( cls ) );
							trace( StdType.getClassFields( cls ) );
						}
					} catch (e:Dynamic) { }
					
				}
				
			}
			
		}
		
		return macro null;
	}
	
	@:macro public static function compile(path:String) {
		var input = MFile.create( FileSystem.fullPath(Context.resolvePath(path)) );
		
		var html = input.readString();
		var xml = Scope.parse(html);
		xml = Validator.parse(xml);
		xml = Binder.parse(xml);
		
		// FileSystem.fullPath stops linux from crying
		var output = MFile.create( 
			PathUtil.cleanUpPath(
				FileSystem.fullPath( Compiler.getOutput().substr( 0, Compiler.getOutput().lastIndexOf('/') + 1 ) )
			)
		);
		
		File.saveContent( 
			PathUtil.cleanUpPath(output.nativePath + MFile.seperator + input.fileName), 
			// I dont know how to add a newline with xml.addChild
			xml.toString() + '\n<!-- Generated with Tem (https://github.com/skial/uhu#readme). -->'
		);
		
		return macro null;
	}
	
}

class Class1 {
	public function new() { }
	public var format(get_format, set_format):Array<String>;
	
	public function get_format():Array<String> { return []; }
	public function set_format(value:Array<String>):Array<String> { return value; }
}

class MyClass1 {
	public function new() { }
	public function fields() { }
	public static var myField = 0;
}

class MyClass2 {
	public function new(bob='') { }
	public function fields() { }
	public static var myField = 0;
}

class YourClass {
	public static function yourField() {}
}
