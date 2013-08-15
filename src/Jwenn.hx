package ;

/**
 * ...
 * @author Skial Bainn
 * jwenn => Find in Haitian Creole 
 */
class Jwenn {
	
	public static function isClass(obj:Dynamic):Bool {
		var result = false;
		
		switch (Type.typeof( obj )) {
			case TClass(_):
				result = true;
				
			case _:
				
		}
		
		return result;
	}
	
}