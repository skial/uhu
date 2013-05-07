package uhx.macro.klas;

import haxe.ds.IntMap;
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
import uhx.macro.Publisher;
import uhx.macro.Subscriber;
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
	
	public static var CLASS_META:StringMap< ClassType->Array<Field>->Array<Field> > = [
		//':implements' => Implements.handler,	// replaced with uhx.macro.Protocol
		//':aop' => AOP.handler,	// doesnt work
		':uhx_to' => To.handler,
		':uhx_alias' => Alias.handler,
		':uhx_pub' => Publisher.handler,
		':uhx_sub' => Subscriber.handler,
	];
	
	public static var CLASS_HAS_FIELD_META:StringMap<String> = [
		':to' => ':uhx_to',
		':pub' => ':uhx_pub',
		':sub' => ':uhx_sub',
		':alias' => ':uhx_alias',
	];
	
	public static function build():Array<Field> {
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		
		if (Context.defined('debug')) {
			trace('-----');
			trace('Class ${cls.path()}');
		}
		
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
			trace('Running class field handlers');
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
				
				if (Context.defined('debug')) {
					trace('${cls.path()} - $matched');
				}
				
				fields = CLASS_META.get( matched )(cls, fields);
				
			}
			
		}
		
		return fields;
	}
	
}