package example.magicGetterSetter;

/**
 * ...
 * @author Skial Bainn
 */
class Main {

	public static function main() {
		trace( hello );
	}
	
	@:isVar public static var hello(get, never):String = 'hi';
	public static var goodbye:String;
	
	private static inline function get_hello():String {
		return __get('hello', hello);
	}
	
	public static function __get<T>(pname:String, pvalue:T):T {
		trace( pname );
		trace( pvalue );
		return pvalue;
	}
	
}