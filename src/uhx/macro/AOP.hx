package uhx.macro;

import haxe.ds.StringMap;
import haxe.ds.StringMap;
import haxe.macro.Printer;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import sys.FileSystem;
import uhu.macro.Du;

using StringTools;
using sys.FileSystem;
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
	
	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		
		if (Context.defined( 'display' )) {
			return fields;
		}
		
		init();
		
		trace('-----');
		
		for (field in fields) {
			
			for (id in [':before', ':after', ':around']) {
				
				var key = cls.path() + '::' + field.name + '@' + id;
				
				if (field.meta.exists( id ) && !fieldCache.exists( key )) {
					
					//	Removes the colon.
					var advice = id.substr( 1 );
					//	Makes first character uppercase.
					advice = advice.charAt( 0 ).toUpperCase() + id.substr( 2 );
					
					var meta = field.meta.get( id );
					var set = { 
						field: field, 
						advice:EAdvice.createByName( advice ), 
						path: meta.params[0].getConst().value(), 
						method: meta.params.length > 1 ? meta.params[1].getConst().value() : null
					};
					
					fieldCache.set( key, set );
					
				}
				
			}
			
		}
		
		search();
		
		return fields;
	}
	
	private static var boolean:Bool = false;
	private static var fieldCache:StringMap<{ field:Field, advice:EAdvice, path:EReg, method:EReg }>;
	private static var typeCache:StringMap<TypeDefinition>;
	private static var nameCache:StringMap<String>;
	
	private static function init() {
		
		if (fieldCache == null) fieldCache = new StringMap<{field:Field, advice:EAdvice, path:EReg, method:EReg}>();
		if (typeCache == null) typeCache = new StringMap<TypeDefinition>();
		if (nameCache == null) nameCache = new StringMap<String>();
		
	}
	
	private static function getAllTypes(ereg:EReg):Array<String> {
		var all = [];
		var paths:Array<String> = Du.classPaths;
		var modules:Array<{ path:String, file:String}> = [];
		
		for (path in paths) {
			var uls = path.readDirectory();
			
			for (ul in uls) {
				if (ul.endsWith('.hx') && ereg.match( ul.replace( path, '' ) )) {
					all.push( ul.replace( path, '' ).replace( '.hx', '' ).replace( '\\', '.' ) );
				}
			}
			
		}
		
		return all;
	}
	
	private static function search() {
		
		for (key in fieldCache.keys()) {
			
			var set = fieldCache.get( key );
			var ids = getAllTypes( set.path );
			
			for (id in ids) {
				
				var name = id;
				var modules = Context.getModule( name );
				
				for (module in modules) {
					var type:TypeDefinition = null;
					
					if (typeCache.exists( module.getName() )) {
						
						type = typeCache.get( module.getName() );
						
						Compiler.exclude( type.path() );
						type.name = type.name + '_';
						Context.defineType( type );
						
						typeCache.set( module.getName(), type );
						
					} else {
						
						type = retype( Context.follow( module ) );
						
						if (type != null) {
							addNativeMeta( type, module.getName() );
							Context.defineType( type );
							typeCache.set( module.getName(), type );
						}
						
					}
					
				}
				
			}
			
		}
		
	}
	
	private static function retype(type:Type):TypeDefinition {
		var result:TypeDefinition = null;
		var original:BaseType = null;
		
		switch (type) {
			case TInst(t, _):
				original = t.get();
				result = t.get().toTypeDefinition('', '_');
				
			case TEnum(t, _):
				original = t.get();
				result = t.get().toTypeDefinition('', '_');
				
			case TType(t, _):
				original = t.get();
				result = t.get().toTypeDefinition('', '_');
				
			case _:
				
		}
		
		if (original != null) original.exclude();
		
		return result;
		
	}
	
	private static function addNativeMeta(type:TypeDefinition, value:String) {
		if (!type.meta.exists(':native')) {
			type.meta.push( { name:':native', params:[macro $v { value } ], pos:type.pos } );
		}
	}
	
}