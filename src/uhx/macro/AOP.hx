package uhx.macro;

import haxe.ds.StringMap;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import massive.sys.util.PathUtil;
import sys.FileSystem;
import uhu.macro.Du;
import uhx.io.File;
import uhx.io.FileSys;
import uhx.util.Path;

using StringTools;
using uhx.io.File;
using uhx.util.Path;
using uhx.io.FileSys;
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
		var isStatic = field.isStatic( cls );
		
		if (Context.defined( 'display' ) || meta.params.length == 0) {
			return fields;
		}
		
		var const = meta.params[0].getConst();
		var allowed = const.isString() || const.isEReg();
		
		if (!allowed) {
			Context.error( '${advice.getName()} metadata for ${cls.name}::${field.name} can only accept Strings & Regular Expressions', field.pos );
		}
		
		var ereg:EReg = null;
		
		if (const.isString()) {
			ereg = new EReg( Std.string( const.value() ), '' );
		} else {
			ereg = const.value();
		}
		
		var paths:Array<File> = Du.getClassPaths();
		var modules:Array<{ path:File, file:File}> = [];
		
		for (path in paths) {
			var uls = path.getRecursiveDirectoryListing( ~/.hx$/ );
			
			for (ul in uls) {
				if (ereg.match( ul.nativePath.replace( path.nativePath, '' ) )) {
					modules.push( { path:path, file:ul } );
				}
			}
			
		}
		
		var types:Array<Type> = [];
		
		for (module in modules) {
			try {
				var path = module.file.nativePath
					.replace( module.path.nativePath, '' )
					.replace( '.hx', '' )
					.replace( File.seperator, '.' );
				types.push( Context.getType( path ) );
			} catch (e:Dynamic) {
				
			}
		}
		
		modules = null;
		paths = null;
		
		for (type in types) {
			
			switch (type) {
				case TInst(t, _):
					var cls = t.get();
					trace( cls.statics.get()[0].toField( true ) );
					var typed:TypeDefinition = {
						pack: cls.pack,
						name: cls.name,
						pos: cls.pos,
						meta: cls.meta.get(),
						params: cls.toTypeParamDecls(),
						isExtern: cls.isExtern,
						kind: cls.toTypeDefKind(),
						fields: []
					}
					
					
				case _:
					trace( type );
			}
			
		}
		
		return fields;
	}
	
}