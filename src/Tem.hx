package ;

/**
 * ...
 * @author Skial Bainn
 */

class Tem {
	
	public static function plate() {
		// Only underbellies here be found...
	}
	
	@:noCompletion public static function parseElement<T>(name:String, ele:dtx.DOMNode, attr:Bool, parse:String->dtx.DOMNode->T):T { 
		return untyped { }; 
	}
	
	@:noCompletion public static function parseCollection<T>(name:String, ele:dtx.DOMNode, attr:Bool, parse:String->dtx.DOMNode->T):Array<T> {  
		return untyped { }; 
	}
	
}