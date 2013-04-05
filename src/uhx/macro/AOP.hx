package uhx.macro;

import haxe.ds.StringMap;
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
		var result = handle( cls, field, meta, Before );
		return result;
	}
	
	public static function after(cls:ClassType, field:Field):Array<Field> {
		var meta = field.meta.get( ':after' );
		var result = handle( cls, field, meta, After );
		return result;
	}
	
	public static function around(cls:ClassType, field:Field):Array<Field> {
		var meta = field.meta.get( ':around' );
		var result = handle( cls, field, meta, Around );
		return result;
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
				// i dont care
			}
		}
		
		// kill these two
		modules = null;
		paths = null;
		
		var expr = null;
		
		if (field.isInline()) {
			switch (field.kind) {
				case FFun(m):
					expr = m.expr;
					
				case FVar(_, e):
					expr = e;
					
				case FProp(_, _, _, e):
					expr = e;
					
			}
		} else {
			expr = macro $i { '${cls.path()}.${field.name}' }();
			//expr = Context.parse( '${cls.path()}.${field.name}()' , field.pos);
			//expr = Context.parseInlineString( '${cls.path()}.${field.name}()' , field.pos);
		}
		
		for (type in types) {
			
			switch (type) {
				case TInst(t, _):
					var cls = t.get();
					var retyped = cls.toTypeDefinition( 'RE_', '_UHX' );
					var fullname = cls.path();
					
					retyped.meta.push( { name:':native', params:[macro '$fullname'], pos:cls.pos } );
					
					if (retyped.fields.exists( field.name )) {
						var f = retyped.fields.get( field.name );
						
						switch (f.kind) {
							case FFun(m):
								
								switch (advice) {
									case After:
										m.expr = m.expr.concat( expr );
									case Before:
										m.expr = expr.concat( m.expr );
									case Around:
										
								}
								
							case _:
								
						}
						
						trace( f.printField() );
						
					}
					
					// first remove the original class from compiling
					Compiler.exclude(fullname, false);
					
					// then add the newly redefined class which has
					// `:native("original class name")` meta
					Context.defineType( retyped );
					
				case _:
					trace( type );
			}
			
		}
		
		return fields;
	}
	
}