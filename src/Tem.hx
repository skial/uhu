package ;

/**
 * ...
 * @author Skial Bainn
 */

class Tem {
	
	public static function plate() {
		// Only underbellies here be found...
	}
	
	@:noCompletion public static function parseSingle<T>(name:String, ele:dtx.DOMNode, attr:Bool, parse:String->dtx.DOMNode->T):T { 
		return untyped { }; 
	}
	
	@:noCompletion public static function parseCollection<T>(name:String, ele:dtx.DOMNode, attr:Bool, parse:String->dtx.DOMNode->T):Array<T> {  
		return untyped { }; 
	}
	
	@:noCompletion public static function setIndividual<T>(value:T, dom:dtx.DOMNode, ?attr:String) {
		
	}
	
	@:noCompletion public static function setCollection<T>(value:Array<T>, dom:dtx.DOMNode, ?attr:String) {
		
	}
	
	@:noCompletion public static function setCollectionIndividual<T>(value:T, pos:Int, dom:dtx.DOMNode, ?attr:String) {
		
	}
	
}