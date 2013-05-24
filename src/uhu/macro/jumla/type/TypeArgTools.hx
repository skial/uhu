package uhu.macro.jumla.type;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class TypeArgTools {
	
	// Auto complete helpers
	
	public static inline function exists(args:Array<{ name : String, opt : Bool, t : Type }>, name:String):Bool {
		return args.exists( name );
	}
	
	public static inline function get(args:Array<{ name : String, opt : Bool, t : Type }>, name:String): { name : String, opt : Bool, t : Type } {
		return args.get( name );
	}
	
	public static inline function indexOf(args:Array<{ name : String, opt : Bool, t : Type }>, name:String, startIndex:Int = 0):Int {
		return args.indexOf( name, startIndex );
	}
	
}