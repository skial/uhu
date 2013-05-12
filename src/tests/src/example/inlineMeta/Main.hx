package example.inlineMeta;

/**
 * ...
 * @author Skial Bainn
 */
@:build( example.inlineMeta.Macro.build() )
class Main {
	
	public static function main() {
		var a:Int, b:Int, c:Int;
		@:wait( success1, _ ) foo( 'Hello ' );
		trace( success1 );
		
		var d:Int, e:Int, f:Int;
		
		@:wait( success2, _ ) foo( 'World' );
		
		success1 += success2;
		trace( success1 );
	}
	
	public static function foo(value:String, cb:String->String->Void) {
		return cb( value, 'b' );
	}
	
}