package example.inline_properties_abstracts;

/**
 * ...
 * @author Skial Bainn
 */
@:build( example.inline_properties_abstracts.BuildMacro.mk() )
class MyStatic {
	
	@:to public static inline var some:Int = 987;
	
	public static var thing(get, never):MyAbstract = 456;
	
	private static inline function get_thing():MyAbstract {
		return new MyAbstract( 456 );
	}
	
}