package uhx.macro.klas;

import haxe.ds.IntMap;
import haxe.macro.Printer;
import haxe.rtti.Meta;
import Type in StdType;
import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.ds.StringMap;
import haxe.macro.Context;
import uhx.macro.Alias;
import uhx.macro.Bind;
import uhx.macro.Implements;
import uhx.macro.To;

using Lambda;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */

class Handler {
	
	public static var CLASS_META:StringMap< ClassType->Array<Field>->Array<Field> > = [
		':implements' => Implements.handler,
	];
	
	public static var FIELD_META_ORDER:IntMap<String> = [
		0 => ':to',
		1 => ':bind',
		2 => ':alias',
	];
	
	public static var FIELD_META:StringMap< ClassType->Field->Array<Field> > = [
		':to' => To.handler,
		':bind' => Bind.handler,
		':alias' => Alias.handler,
	];

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
		
		for (key in CLASS_META.keys()) {
			
			if (cls.meta.has( key )) {
				
				fields = CLASS_META.get( key )( cls, fields );
				
			}
			
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
		
		for (i in 0...FIELD_META.count()) {
			
			var key = FIELD_META_ORDER.get( i );
			
			for (field in fields) {
				
				if (new_fields.exists( field.name )) {
					field = new_fields.get( field.name );
					new_fields.remove( field );
				}
				
				if (field.meta.exists( key )) {
					
					var results = FIELD_META.get( key )( cls, field );
					new_fields = new_fields.concat( results );
					
				} else {
					
					new_fields.push( field );
					
				}
				
			}
			
		}
		
		fields = new_fields;
		
		return fields;
	}
	
}