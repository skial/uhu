package example.inlineMeta;

/**
 * ...
 * @author Skial Bainn
 */
@:build( example.inlineMeta.Macro.build() )
class Main {
	
	public static function main() {
		@:wait( aa, bb, cc, dd ) js.Browser.window.requestFileSystem( 0, 1024 );
		@:wait( a1, a2, a3, a4 ) bar( 'Hello' );
		var a:Int, b:Int, c:Int;
		/*@:wait( success1, _ ) foo( 'Hello ' );
		trace( success1 );
		
		var d:Int, e:Int, f:Int;
		
		@:wait( success2, _ ) foo( 'World' );
		
		success1 += success2;
		trace( success1 );*/
	}
	
	public static function foo(value:String, cb:String->String->Void) {
		return cb( value, 'b' );
	}
	
	public static function bar(value:String, cb1:String->String->Void, cb2:String->String->Void) {
		if (value == '') cb1(value, 'b') else cb2(value, 'c');
	}
	
}