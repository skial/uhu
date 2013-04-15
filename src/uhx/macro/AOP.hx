package uhx.macro;

import haxe.ds.StringMap;
import haxe.ds.StringMap;
import haxe.macro.Printer;
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
	
	private static var allTypes:Array<Type>;
	private static var redefined:StringMap<TypeDefinition>;
	
	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		
		if (Context.defined( 'display' )) {
			return fields;
		}
		
		redefined = new StringMap<TypeDefinition>();
		
		for (field in fields) {
			
			if (field.meta.exists( ':before' )) {
				
				handle( cls, field, field.meta.get( ':before' ), Before );
				
			} else if (field.meta.exists( ':after' )) {
				
				handle( cls, field, field.meta.get( ':after' ), After );
				
			} else if (field.meta.exists( ':around' )) {
				
				handle( cls, field, field.meta.get( ':around' ), Around );
				
			}
			
		}
		
		for (key in redefined.keys()) {
			var re = redefined.get( key );
			Context.defineType( re );
			allTypes.push( Context.getType( re.path() ) );
		}
		
		redefined = null;
		
		return fields;
	}
	
	private static function getAllTypes(ereg:EReg):Array<Type> {
		
		if (allTypes == null) {
			var paths:Array<File> = Du.classPaths;
			var modules:Array<{ path:File, file:File}> = [];
			
			for (path in paths) {
				var uls = path.getRecursiveDirectoryListing( ~/.hx$/ );
				
				for (ul in uls) {
					if (ereg.match( ul.nativePath.replace( path.nativePath, '' ) )) {
						modules.push( { path:path, file:ul } );
					}
				}
				
			}
			
			allTypes = [];
			
			for (module in modules) {
				try {
					var path = module.file.nativePath
						.replace( module.path.nativePath, '' )
						.replace( '.hx', '' )
						.replace( File.seperator, '.' );
					
					var type = Context.getType( path );
					type = Context.follow( type );
					allTypes.push( type );
				} catch (e:Dynamic) {
					// i dont care
				}
			}
			
			// kill these two
			modules = null;
			paths = null;
		}
		
		return allTypes;
	}
	
	private static function handle(cls:ClassType, field:Field, meta:MetadataEntry, advice:EAdvice)/*:Array<Field>*/ {
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
		
		var types = getAllTypes( ereg );
		var expr = Context.parse( '${cls.path()}.${field.name}()', field.pos );
		var clone = types.copy();
		
		for (type in clone) {
			
			switch (type) {
				case TInst(t, _):
					var cls = t.get();
					var fullname = cls.path();
					var retyped:TypeDefinition = null;
					
					if (redefined.exists( fullname )) {
						retyped = redefined.get( fullname );
					} else {
						retyped = cls.toTypeDefinition( 'RE_', '_UHX' );
						redefined.set( fullname, retyped );
					}
					
					if (!retyped.meta.exists( ':keep' )) {
						retyped.meta.push( { name:':keep', params:[], pos:cls.pos } );
					}
					
					if (!retyped.meta.exists( ':native')) {
						retyped.meta.push( { name:':native', params:[macro '$fullname'], pos:cls.pos } );
					}
					
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
						
					}
					
					// remove the original class from compiling
					Compiler.exclude(fullname, false);
					allTypes.remove( type );
					
				case _:
					trace( type );
			}
			
		}
		
	}
	
}