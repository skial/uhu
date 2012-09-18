package uhu.js.mini;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import neko.FileSystem;
import neko.io.File;
import neko.io.FileOutput;
import neko.Lib;
import neko.Sys;
import tink.macro.tools.Printer;
import tink.macro.tools.TypeTools;

using Lambda;
using StringTools;

/**
 * ...
 * @author Skial Bainn
 */

typedef VarDetails = {
	var name:String;
	var type:String;
}

typedef VarType = {
	var name:String;
	var params:Array<String>;
}

class MiniBuild {

	public static var file:FileOutput;
	public static var deadExpr:Array<Expr>;
	
	private static var IDs:Array<String> = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
	private static var counter:Int = 0;
	private static var prefix:Array<String> = new Array<String>();
	
	@:macro
	public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		var localClass:ClassType = Context.getLocalClass().get();
		
		if (!localClass.isExtern) {
			
			#if mini_dump
			file = File.write('log.txt');
			#end
			
			for (f in fields) {
				switch(f.kind) {
					case FFun(a):
						processFunction(f, a);
					default:
				}
			}
			
			/*if (localClass.meta.has(':native') == false) {
				
				var _new:String = prefix.join('') + IDs[counter];
				
				if (counter > IDs.length) {
					
					var _number = prefix.length;
					if (_number > 0) {
						
						var _letter = prefix[ -1];
						
						if (_letter == IDs[-1]) {
							prefix.push(IDs[0]);
						} else {
							var id_index = IDs.join('').indexOf(_letter);
							var pr_index = prefix.length - 1;
							prefix[pr_index] = IDs[(id_index + 1)];
						}
						
					}
					
				}
				++counter;
				
				#if mini_dump
				file.writeString('\nnew native : ' + _new);
				#end
				
				localClass.meta.add(':native', [{ expr:EConst(CString(_new)), pos:Context.currentPos() }], Context.currentPos());
			}*/
			
			#if mini_dump
			file.writeString('\nmeta : ' + localClass.meta.get());
			file.close();
			#end
			
		}
		
		return fields;
	}
	
	public static function processFunction(field:Field, func:Function):Void {
		if (func.expr != null && field.name != 'main') {
			#if mini_dump
			file.writeString('\nargs : ' + func.args);
			file.writeString('\nexpr : ' + func.expr);
			#end
			switch (func.expr.expr) {
				case EBlock(e):
					convertVariables(field, func, e);
				default:
			}
		}
	}
	
	public static function convertVariables(field:Field, func:Function, exprs:Array<Expr>):Void {
		var _i:Int = 0;
		deadExpr = new Array<Expr>();
		
		for (e in exprs) {
			switch (e.expr) {
				case EVars(v):
					for (a in v) {
						
						var arg:FunctionArg = { name:a.name, opt:true, type:a.type, value:null };
						func.args.push(arg);
						
						
						var type:String = try { TypeTools.toString(a.type); } catch (e:Dynamic) { 'Dynamic'; }
						
						var value:String = ' = ' + Printer.print(a.expr);
						if (value == ' = #NULL' || value == ' = #MALFORMED') value = ''; 
						
						if (value != '') {
							var ex:Expr = Context.parse(a.name + value, e.pos);
							
							exprs[_i] = ex;
						}
						
						deadExpr.push(e);
						
						#if mini_dump
						/*file.writeString('\nlength : ' + v.length);
						//file.writeString('\ntink : ' + TypeTools.toString(a.type));
						file.writeString('\nold expr : ' + e);
						//file.writeString('\nnew expr : ' + ex);*/
						#end
					}
				default:
			}
			++_i;
		}
		
		#if mini_dump
		file.writeString('\nold array exprs : ' + exprs);
		#end
		for (d in deadExpr) {
			if (exprs.has(d)) exprs.remove(d);
		}
		#if mini_dump
		file.writeString('\nnew array exprs : ' + exprs);
		#end
	}
	
}
	