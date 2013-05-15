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
	
	public static function follow(path:String) {
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		var parts = path.split( '.' );
		var calls = [];
		
		while (parts.length != 0) {
			
			var name = parts.pop();
			
			if (parts.length == 0 && fields.exists( name )) {
				
				calls.push( name );
				parts = cls.pack;
				name = cls.name;
				
			}
			
			try {
				
				var tpath = TPath( { pack: parts, name: name, params: [], sub: null } );
				if (calls.length > 1) calls.reverse();
				
				var type:Type = ComplexTypeTools.toType( tpath );
				
				trace( type.resolve( calls ) );
				
				break;
				
			} catch (e:Dynamic) {
				
				calls.push( name );
				
			}
			
		}
	}
	
}