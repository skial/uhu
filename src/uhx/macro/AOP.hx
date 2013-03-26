package uhx.macro;

import haxe.ds.StringMap;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import sys.FileSystem;

using StringTools;
using haxe.EnumTools;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */

typedef TJoinPoint<TClass, TMethod> = {
	var cls:TClass;
	var name:String;
	var args:Array<{ name:String, opt:Bool, value:Null<Dynamic> }>;
	var vars:Array<{ name:String, value:Null<Dynamic> }>;
	var proceed:TMethod;
}

private enum EAdvice {
	After;
	Before;
	Around;
}
 
class AOP {
	
	public static var shortcuts:StringMap<EReg> = [
		'*' => ~/^([\w]+[\.])*([\w]+)$/i,
	];
	
	public static function before(cls:ClassType, field:Field):Array<Field> {
		var meta = field.meta.get( ':before' );
		return handle( cls, field, meta, Before );
	}
	
	public static function after(cls:ClassType, field:Field):Array<Field> {
		var meta = field.meta.get( ':after' );
		return handle( cls, field, meta, After );
	}
	
	public static function around(cls:ClassType, field:Field):Array<Field> {
		var meta = field.meta.get( ':around' );
		return handle( cls, field, meta, Around );
	}
	
	private static function handle(cls:ClassType, field:Field, meta:MetadataEntry, advice:EAdvice):Array<Field> {
		var fields = [ field ];
		
		if (Context.defined( 'display' ) || meta.params.length == 0) {
			return fields;
		}
		
		var ereg = meta.params[0].getConst().isEReg();
		
		if (!ereg) {
			Context.error( '${advice.getName()} metadata for ${cls.name}::${field.name} can only accept Regular Expressions', field.pos );
		}
		
		var paths = Context.getClassPath();
		
		for (i in 0...paths.length) {
			
			var path = paths[i].replace('\\', '/');
			
			if (path.endsWith('/')) {
				path.substr(0, -1);
			}
			
			if (path == '') {
				path = '.';
			}
			
			paths[i] = FileSystem.fullPath( path );
			
		}
		
		trace(paths);
		
		return fields;
	}
	
}