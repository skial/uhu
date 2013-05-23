package uhu.macro.jumla;

import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.ComplexTypeTools;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class Common {
	
	public static function remove< T: { name:String } >(obj:Array<T>, key:String):Bool {
		var result = false;
		var target = null;
		
		if (obj != null && obj.length > 0) {
			
			for (o in obj) {
				
				if (o.name == key) {
					target = o;
					break;
				}
				
			}
			
			if (target != null) {
				result = obj.remove( target );
			}
			
		}
		
		return result;
	}
	
	public static function get< T: { name:String } >(obj:Array<T>, key:String):T {
		var result = null;
		
		if (obj != null && obj.length > 0) {
			
			for (o in obj) {
				
				if (o.name == key) {
					result = o;
					break;
				}
				
			}
			
		}
		
		return result;
	}
	
	public static function exists< T: { name:String } >(obj:Array<T>, key:String):Bool {
		var result = false;
		
		if (obj != null && obj.length > 0) {
			
			for (o in obj) {
				
				if (o.name == key) {
					
					result = true;
					break;
					
				}
				
			}
			
		}
		
		return result;
	}
	
	public static function getAll< T: { name:String } >(obj:Array<T>, key:String):Array<T> {
		var result:Array<T> = [];
		
		if (obj != null && obj.length > 0) {
			
			for (o in obj) {
				
				if (o.name == key) {
					result.push( o );
				}
				
			}
			
		}
		
		return result;
	}
	
}