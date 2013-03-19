package uhx.macro.klas;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.ds.StringMap;
import haxe.macro.Context;
import uhx.macro.Alias;
import uhx.macro.Implements;
import uhx.macro.ToType;

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
	
	public static var HAS_META:StringMap < ClassType-> Array<Field>->Array<Field> > = [
		':toInt' => ToType.handler,
		':toString' => ToType.handler,
	];
	
	public static var FIELD_META:StringMap < ClassType-> Field->Array<Field> > = [
		':alias' => Alias.handler,
	];

	public static function build():Array<Field> {
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		
		/**
		 * Loop through any class metadata and pass along 
		 * the class and its fields to the matching handler.
		 */
		
		for (key in CLASS_META.keys()) {
			
			if (cls.meta.has( key )) {
				
				fields = CLASS_META.get( key )( cls, fields );
				
			}
			
		}
		
		/**
		 * Now detect if any field has matching metadata to
		 * those in HAS_META.
		 */
		
		var matches:Array<String> = [];
		
		for (field in fields) {
			
			for (key in HAS_META.keys()) {
				
				if (field.meta.exists( key ) && matches.indexOf( key ) == -1) {
					
					matches.push( key );
					break;
					
				}
				
			}
			
		}
		
		/**
		 * Now detect per field metadata.
		 */
		
		var new_fields:Array<Field> = [];
		
		for (field in fields) {
			
			for (key in FIELD_META.keys()) {
				
				if (field.meta.exists( key )) {
					
					new_fields = new_fields.concat( FIELD_META.get( key )(cls, field) );
					
				} else {
					
					new_fields.push( field );
					
				}
				
			}
			
		}
		
		return new_fields;
	}
	
}