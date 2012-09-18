package uhu.js.mini;

import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Type;
import neko.FileSystem;
import neko.io.File;
import neko.io.FileOutput;
using StringTools;
using Lambda;

/**
 * ...
 * @author Skial Bainn
 */

class Test {
	
	#if mini_dump
	private static var file:FileOutput;
	#end
	
	private static var patch:FileOutput;
	private static var modules:Array<String> = new Array<String>();
	private static var patchList:Array<String> = new Array<String>();
	private static var hx_targets:Array<String> = ['neko', 'cpp', 'php', 'flash'];
	private static var hx_packages:Array<String> = ['sys', 'neko', 'cpp', 'php', 'flash'];

	public static function run():Void {
		if (Context.defined('js')) {
			var cls_path:Array<String> = Context.getClassPath();
			
			#if mini_dump
			file = File.write('macro.txt');
			file.writeString('\n' + cls_path);
			#end
			
			for (n in cls_path) {
				
				// force motion-twin/haxe/std/neko/_std to be js instead
				// as classpath ignores the real compiler target
				if (n.indexOf('_std') != -1) {
					for (t in hx_targets) {
						if (n.indexOf(t) == -1) {
							continue;
						} else {
							n = n.replace(t, 'js');
						}
					}
				}
				
				if (n.trim() != '' && n.indexOf('Motion-Twin') == -1) {
					var path = FileSystem.fullPath(n);
					path = path.substr(0, path.length - 1);
					
					#if mini_dump
					file.writeString('\n' + path);
					#end
					
					findHXFiles(path);
				}
				
			}
			
			#if mini_dump
			file.writeString('\n---packages---');
			#end
			
			for (n in modules) {
				Compiler.addMetadata('@:build(uhu.js.mini.MiniBuild.build())', n);
			}
			
			#if mini_dump
			file.writeString('\n' + modules);
			file.writeString('\n' + patchList);
			file.close();
			#end
		}
	}
	
	private static function findHXFiles(path:String, ?pack:String = ''):Void {
		var p:String = '';
		if (FileSystem.exists(path) && FileSystem.isDirectory(path)) {
			for (d in FileSystem.readDirectory(path)) {
				#if mini_dump
				file.writeString('\n\t' + d);
				#end
				
				p = pack == '' ? d.replace('.hx', '') : pack + '.' + d.replace('.hx', '');
				
				if (d.endsWith('.hx')) modules.push(p);
				if (FileSystem.isDirectory(path + '\\' + d)) findHXFiles(path + '\\' + d, p);
			}
		}
	}
	
	
}