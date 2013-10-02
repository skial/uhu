package uhx.sys;

import haxe.rtti.Meta;
import haxe.ds.StringMap;

using Type;
using Jwenn;
using Reflect;

/**
 * ...
 * @author Skial Bainn
 * liy => Line in Haitian Creole 
 */
class Liy {
	
	public var obj:Dynamic;
	public var fields:Array<String>;
	public var args:StringMap<Array<Dynamic>>;
	public var meta:Dynamic<Dynamic<Array<Dynamic>>>;

	public function new() {
		
	}
	
	public function parse():Void {
		var checks:Array<Dynamic> = [obj, fields, meta, args];
		for (nul in checks) {
			if (nul == null) throw '[obj, fields, meta, args] can not be null';
		}
		
		process( fields );
	}
	
	private function process(fields:Array<String>) {
		
		for (field in fields) {
			
			// get all possible names and aliases
			// also, try and get the fields arity, if possible
			var names = [field];
			var arity = 0;
			
			if (meta.hasField( field )) {
				
				if (meta.field( field ).hasField( 'alias' )) {
					names = names.concat( meta.field( field ).alias );
				}
				
				if (meta.field( field ).hasField( 'arity' )) {
					arity = meta.field( field ).arity[0];
				}
				
			}
			
			// collect all possible values from each name
			var values = [];
			
			for (name in names) {
				
				if (args.exists( name )) values = values.concat( args.get( name ) );
				
			}
			
			if (values.length != 0) {
			
				var f = Reflect.field( obj, field );
				if (Reflect.isFunction( f )) {
					
					Reflect.callMethod( obj, f, values.slice( 0, arity ) );
					
				} else if (values.length > 0) {
					
					Reflect.setField( obj, field, values[0] );
					
				}
				
			}
			
		}
		
	}
	
}