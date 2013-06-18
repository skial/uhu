package uhu.macro;

import haxe.io.Eof;
import haxe.macro.Type;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;

using StringTools;
using sys.FileSystem;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */

// Haitian Creole for compiler
class Du {
	
	private static var defines:Array<String> = ['js', 'swf', 'as3', 'neko', 'php', 'cpp', 'cs', 'java', 'sys'];
	
	public static macro function addDefine(name:String) {
		defines.push( name );
		return null;
	}
	
	@:isVar public static var target(get, null):String;
	
	private static function get_target():String {
		if (target == null) {
			for (define in defines) {
				if (Context.defined( define )) {
					target = define;
					break;
				}
			}
		}
		
		return target;
	}
	
	@:isVar public static var classPaths(get, null):Array<String>;
	
	private static function get_classPaths():Array<String> {
		if (classPaths == null) {
			classPaths = [];
			
			for (path in Context.getClassPath()) {
				
				if (path.endsWith('/')) {
					path.substr(0, -1);
				}
				
				if (path == '') {
					path = '.';
				}
				
				path = path.fullPath();
				
				classPaths.push( path );
				
			}
		}
		
		return classPaths;
	}
	
	public static macro function include(classes:Array<String>) {
		for (cls in classes) {
			//Context.getModule(cls);
			Compiler.include(cls);
		}
		return macro null;
	}

	public static macro function patchTypes(file:String) {
		var file = sys.io.File.read(Context.resolvePath(file), true);
		try {
			while (true) {
				var line = file.readLine().trim();
				
				if (line == '' || line.substr(0, 2) == '//') {
					continue;
				}
				
				if (line.endsWith(';')) {
					line = line.substr(0, -1);
				}
				
				if (line.charAt(0) == '-') {
					line = line.substr(1);
					var isStatic = line.startsWith('static');
					if (isStatic) {
						line = line.substr(7);
					}
					var pck = line.split('.');
					var field = pck.pop();
					haxe.macro.Compiler.removeField(pck.join('.'), field, isStatic);
					continue;
				}
				
				if (line.charAt(0) == '@') {
					var split = line.split(' ');
					var type = split.pop();
					var isStatic = split[split.length - 1] == 'static';
					if (isStatic) {
						split.pop();
					}
					var meta = split.join(' ');
					
					var pck:Dynamic;
					var field:Dynamic;
					if (type.indexOf('.') == -1) {
						pck = type;
						field = null;
					} else {
						pck = type.split('.');
						field = (pck.length > 1) ? null : pck.pop();
						pck = pck.join('.');
					}
					
					haxe.macro.Compiler.addMetadata(meta, pck, field, isStatic);
					continue;
				}
				
				if (line.startsWith('enum ')) {
					haxe.macro.Compiler.define('fakeEnum:' + line.substr(5));
					continue;
				}
				
				var array = line.split(' : ');
				if (array.length > 1) {
					line = array.shift();
					var isStatic = line.startsWith('static');
					if (isStatic) {
						line = line.substr(7);
					}
					var pck = line.split('.');
					var field = pck.pop();
					haxe.macro.Compiler.setFieldType(pck.join('.'), field, array.join(' : '), isStatic);
					continue;
				}
				
				throw 'Invalid type patch ' + line;
			}
		} catch (e:Eof) {
			
		}
		return macro null;
	}
	
}