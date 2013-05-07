package uhx.macro.klas;

import haxe.ds.IntMap;
import haxe.macro.Printer;
import haxe.rtti.Meta;
import sys.FileSystem;
import Type in StdType;
import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.ds.StringMap;
import haxe.macro.Context;
import uhu.macro.Du;
import uhx.macro.Alias;
import uhx.macro.AOP;
import uhx.macro.Bind;
import uhx.macro.Implements;
import uhx.macro.To;

using Lambda;
using StringTools;
using sys.FileSystem;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */

class Handler {
	
	public static var CLASS_MANDATORY:StringMap<String> = [
		':bind' => ':uhx_bind',
	];
	
	public static var CLASS_META:StringMap< ClassType->Array<Field>->Array<Field> > = [
		':implements' => Implements.handler,
		//':aop' => AOP.handler,	// doesnt work
		':uhx_bind' => Bind.handler,
	];
	
	public static var FIELD_META_ORDER:IntMap<String> = [
		0 => ':to',
		1 => ':alias',
	];
	
	public static var FIELD_META:StringMap< ClassType->Field->Array<Field> > = [
		':to' => To.handler,
		':alias' => Alias.handler,
	];
	
	public static var CLASS_HAS_FIELD_META:StringMap<String> = [
		//':before' => ':aop',
		//':after' => ':aop',
		//':around' => ':aop',
		':bind' => ':uhx_bind',
	];
	
	/**
	 * First attempt at marking every class with my build macro.
	 * Currently running into package restriction issues - 
	 * sys access from js
	 */
	/*public static function init() {
		for (path in Du.classPaths) {
			
			for (sub in path.readDirectory()) {
				
				try {
					if (sub.endsWith('.hx')) {
						var name = sub
							.replace( path, '' )
							.replace( '.hx', '' )
							.replace( '\\', '.' );
						
						Compiler.addMetadata('@:build(uhx.macro.klas.Handler.init())', name);
						
						var type = Context.getType( name );
						type = Context.follow( type );
					}
				} catch (e:Dynamic) {
					
				}
				
			}
			
		}
		return  null;
	}*/
	
	public static function build():Array<Field> {
		var p = new Printer();
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		
		/**
		 * Loop through any class metadata and pass along 
		 * the class and its fields to the matching handler.
		 * -----
		 * Each handler should decide if its needed to be run
		 * while in IDE display mode, `-D display`.
		 */
		
		if (Context.defined('debug')) {
			trace('-----');
			trace('Running class handlers');
		}
		
		for (key in CLASS_META.keys()) {
			
			if (cls.meta.has( key )) {
				
				if (Context.defined('debug')) {
					trace('${cls.path()} - $key');
				}
				
				fields = CLASS_META.get( key )( cls, fields );
				
			}
			
		}
		
		if (Context.defined('debug')) {
			trace('-----');
			trace('Running class fields handlers');
		}
		
		var matched = null;
		
		for (key in CLASS_HAS_FIELD_META.keys()) {
			
			for (f in fields) {
				
				if (f.meta.exists( key ) && CLASS_META.exists( CLASS_HAS_FIELD_META.get( key ) )) {
					
					matched = CLASS_HAS_FIELD_META.get( key );
					break;
					
				}
				
			}
			
		}
		
		if (matched != null) {
			
			if (Context.defined('debug')) {
				trace('${cls.path()} - $matched');
			}
			
			fields = CLASS_META.get( matched )(cls, fields);
			
		}
		
		/**
		 * Now detect per field metadata.
		 * -----
		 * The modified field MUST retain all the original 
		 * metadata.
		 * -----
		 * Each handler should decide if its needed to be run
		 * while in IDE display mode, `-D display`.
		 * -----
		 * Assume that the field will be malformed by a previous
		 * macro. So always cleanup.
		 */
		
		var new_fields:Array<Field> = [];
		
		/*for (field in fields) {
			
			for (key in FIELD_META.keys()) {
				
				if (field.meta.exists( key )) {
					
					var results = FIELD_META.get( key )(cls, field);
					field = results.get( field.name );
					results.remove( field );
					new_fields = new_fields.concat( results );
					
				}
				
			}
			
			new_fields.push( field );
			
		}*/
		
		if (Context.defined('debug')) {
			trace('-----');
			trace('Running field handlers');
		}
		
		for (i in 0...FIELD_META.count()) {
			
			var key = FIELD_META_ORDER.get( i );
			
			for (field in fields) {
				
				if (new_fields.exists( field.name )) {
					field = new_fields.get( field.name );
					new_fields.remove( field );
				}
				
				if (field.meta.exists( key )) {
					
					if (Context.defined('debug')) {
						trace('${cls.path()}::${field.name} - $key');
					}
					
					var results = FIELD_META.get( key )( cls, field );
					new_fields = new_fields.concat( results );
					
				} else {
					
					new_fields.push( field );
					
				}
				
			}
			
		}
		
		fields = new_fields;
		
		if (Context.defined('debug')) {
			trace('-----');
			trace('Running mandatory handlers');
		}
		
		// Force mandatory handlers to be run.
		for (key in CLASS_MANDATORY.keys()) {
			key = CLASS_MANDATORY.get( key );
			
			if (CLASS_META.exists( key )) {
				
				if (Context.defined('debug')) {
					trace('${cls.path()} - $key');
				}
				
				fields = CLASS_META.get( key )( cls, fields );
				
			}
			
		}
		
		return fields;
	}
	
}