package example.inline_properties_abstracts;

/**
 * ...
 * @author Skial Bainn
 */
abstract MyAbstract(Int) {

	public inline function new(v:Int) {
		this = v;
	}
	
	@:from public static inline function fromInt(v:Int):MyAbstract {
		return new MyAbstract( v );
	}
	
	@:to public inline function toString():String {
		return '+++';
	}
	
}