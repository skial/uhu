package uhx.macro.klas;

import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import Type in StdType;
import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.ds.StringMap;
import haxe.macro.Context;
import uhu.macro.Du;
import uhx.db.macro.DBConfig;
//import uhx.db.macro.DBConfig;
//import uhx.macro.Alias;
//import uhx.macro.Publisher;
//import uhx.macro.Subscriber;
//import uhx.macro.Tem.TemMacro;
//import uhx.macro.To;
import uhx.macro.EThis;
import uhx.macro.NamedArgs;
/*import uhx.macro.Wait;
import uhx.macro.Bind;
import uhx.macro.Forward;
import uhx.macro.Test;
import uhx.sys.Ede;*/

using Lambda;
using StringTools;
using sys.FileSystem;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */

class Handler {
	
	@:isVar public static var setup(get, null):Bool;
	
	private static function get_setup():Bool {
		if (setup == null) {
			setup = true;
			return false;
			
		}
		
		return true;
	}
	
	public static function initalize() {
		DEFAULTS = [EThis.handler, NamedArgs.handler, /*DBConfig.handler*/];
		CLASS_META = new StringMap();
	}
	
	public static var DEFAULTS:Array < ClassType->Array<Field>->Array<Field> > = [];
	
	private static function dirLoop(dir:String, ?pack:String = ''):Array<String> {
		var results = [];
		
		for (d in FileSystem.readDirectory( dir )) if (FileSystem.isDirectory( dir + '/' + d )) {
			results = results.concat( dirLoop( dir + '/' + d, pack == '' ? d : pack + '.' + d ) );
		} else if (d.endsWith('.hx')) {
			results.push( (pack == '' ? '' : pack + '.') + d.replace('.hx', '') );
		}
		
		return results;
	}
	
	public static var CLASS_META:StringMap< ClassType->Array<Field>->Array<Field> >;
	
	//public static var CLASS_META:StringMap< ClassType->Array<Field>->Array<Field> > = [
		//':implements' => Implements.handler,	// replaced with uhx.macro.Protocol
		//':aop' => AOP.handler,	// doesnt work
		//':tem' => TemMacro.handler,
		//':cmd' => Ede.handler,
		//':uhx_to' => To.handler,
		//':uhx_alias' => Alias.handler,	// causes more trouble than it's worth
		//':uhx_pub' => Publisher.handler,	// no future
		//':uhx_sub' => Subscriber.handler,	// no future
		//':db' => DBConfig.handler,
	//];
	
	public static var CLASS_HAS_FIELD_META:StringMap<String> = [
		'' => '',
		//':to' => ':uhx_to',
		//':pub' => ':uhx_pub',
		//':sub' => ':uhx_sub',
		//':alias' => ':uhx_alias',
	];
	
	private static var reTypes:Array<ClassType->Array<Field>->TypeDefinition> = [];
	
	public static function registerForReType(callback:ClassType->Array<Field>->TypeDefinition):Void {
		reTypes.push( callback );
	}
	
	public static function build():Array<Field> {
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		
		if (!setup) initalize();
		if (cls.meta.has(':KLAS_SKIP')) return fields;
		
		reTypes = [];
		
		#if debug_macros
		trace( cls.path() );
		#end
		
		/**
		 * Loop through any class metadata and pass along 
		 * the class and its fields to the matching handler.
		 * -----
		 * Each handler should decide if its needed to be run
		 * while in IDE display mode, `-D display`.
		 */
		
		for (key in CLASS_META.keys()) {
			
			if (cls.meta.has( key )) {
				
				#if debug_macros
				trace( key );
				#end
				fields = CLASS_META.get( key )( cls, fields );
				
			}
			
		}
		
		for (key in CLASS_HAS_FIELD_META.keys()) {
			
			var matched = null;
			
			for (f in fields) {
				
				if (f.meta.exists( key ) && CLASS_META.exists( CLASS_HAS_FIELD_META.get( key ) )) {
					
					matched = CLASS_HAS_FIELD_META.get( key );
					break;
					
				}
				
			}
			
			if (matched != null) {
				
				#if debug_macros
				trace( matched );
				#end
				fields = CLASS_META.get( matched )(cls, fields);
				
			}
			
		}
		
		for (def in DEFAULTS) {
			#if debug_macros
			trace( switch (Lambda.indexOf(DEFAULTS, def)) {
				case 0: 'Wait';
				case 1: 'NamedArgs';
				case 2: 'EThis';
				case _: 'Not Implemented';
			} );
			#end
			fields = def( cls, fields );
		}
		
		// Really sad that I have to destroy and rebuild a class just to get what I want...
		// All callbacks handle the rename hack. @:native('orginal.package.and.Name')
		// All retyped classes should not modify the fields further.
		for (callback in reTypes) {
			var td = callback( cls, fields );
			
			if (td == null) continue;
			
			switch( td.kind ) {
				case TDClass(c, _, _):
					
					try {
						Context.getType( c.path() );
					} catch (e:Dynamic) {
						POSTPONED.set( c.path(), td );
						LINEAGE.set( c.path(), td.path() );
						continue;
					}
					
				case _:
			}
			// Unfortuantly for this to work, all types must
			// be in referenced by their full path. So Array<MyClass>
			// must be Array<my.pack.to.MyClass>. This what the code
			// below does.
			/*for (field in td.fields) {
				switch (field.kind) {
					case FVar(t, e):
						trace( t );
						if (t != null) {
							t = t.qualify();
						} else if (e != null) {
							t = Context.toComplexType( Context.typeof( e ) );
						} else {
							trace( field.name );
						}
						field.kind = FVar(t, e);
						trace( t );
					case FProp(g, s, t, e):
						if (t != null) {
							t = t.qualify();
						} else if (e != null) {
							t = Context.toComplexType( Context.typeof( e ) );
						} else {
							trace( field.name );
						}
						field.kind = FProp(g, s, t, e);
						
					case FFun(method):
						for (arg in method.args) {
							if (arg.type != null) {
								arg.type = arg.type.qualify();
							}
						}
						
				}
			}*/
			buildLineage( td.path() );
			
			/*switch (td.kind) {
				case TDClass(s, i, b): i.remove( { name: 'Klas', pack: [], params: [] } );
				case _:
			}*/
			trace( td.printTypeDefinition() );
			Compiler.exclude( cls.path() );
			Context.defineType( td );
			//Context.getType( td.path() );
		}
		
		return fields;
	}
	
	private static var POSTPONED:StringMap<TypeDefinition> = new StringMap<TypeDefinition>();
	private static var LINEAGE:StringMap<String> = new StringMap<String>();
	
	private static function buildLineage(path:String) {
		//trace( path );
		for (k in LINEAGE.keys() ) trace( k, LINEAGE.get( k ) );
		for (k in POSTPONED.keys() ) trace( k, POSTPONED.get( k ) );
		if (LINEAGE.exists( path ) && POSTPONED.exists( path )) {
			
			var td = POSTPONED.get( path );
			buildLineage( td.path() );
			
			trace( td.printTypeDefinition() );
			//Compiler.exclude( path );
			Context.defineType( td );
			
		}
	}
	
}