package uhu.macro;

import haxe.io.Eof;
import haxe.macro.Type;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import massive.neko.io.File;
import massive.neko.io.FileSys;
import massive.neko.util.PathUtil;
import sys.FileSystem;

using StringTools;

/**
 * ...
 * @author Skial Bainn
 */

// Haitian Creole for compiler
class Du {
	
	@:macro public static function getAllClasses():ExprOf<Array<String>> {
		// This method NEEDS to be cached.
		
		if (Context.defined('display')) return macro [];
		
		var cls_path = Context.getClassPath();
		var result:Array<String> = [];
		var path:String = '';
		var file:File;
		var files:Array<File>;
		
		for (cls in cls_path) {
			
			if (cls != '') {
				
				file = File.create(PathUtil.cleanUpPath(FileSystem.fullPath(cls)));
				// Using MassiveInteractive's File.hx class feels to heavy just for this
				// but I like writing as little code as I can :D
				files = file.getRecursiveDirectoryListing(~/.hx/);
				for (f in files) {
					result.push(f.nativePath);
				}
				
			}
			
		}
		
		return macro $(result);
	}
	
	@:macro public static function include(classes:Array<String>) {
		for (cls in classes) {
			Context.getModule(cls);
		}
		return macro null;
	}

	@:macro public static function patchTypes(file:String) {
		var file = neko.io.File.read(Context.resolvePath(file), true);
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