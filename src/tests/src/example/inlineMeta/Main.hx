package example.inlineMeta;

/**
 * ...
 * @author Skial Bainn
 */
@:build( example.inlineMeta.Macro.build() )
class Main {
	
	public static function main() {
		var a1, a2, a3, a4;
		var b1, b2, b3, b4;
		var c1, c2, c3, c4;
		var d1, d2, d3, d4;
		var e1, e2, e3, e4;
		// If metadata params are empty, then assume all array declerations are method markers.
		@:wait js.Browser.window.requestFileSystem( 0, 1024, [suc0], [err0] );
		
		var a, b, c;
		
		// If metadata params exist and no wildcard params exist, then method markers are appended to method signature.
		@:wait( [suc1], [err1] ) js.Browser.window.requestFileSystem( 0, 1024 );
		
		var d, e, f;
		
		// If metadata params exist and wildcard params exist, replace wilcards with metadata params.
		@:wait( [suc2], [err2] ) js.Browser.window.requestFileSystem( 0, 1024, _, _ );
		
		var g, h, i;
		
		@:wait foo( 'Hello', [suc] );
		
		var j, k, l;
		
		@:wait( [a, b], [c] ) bar( 'Hello' );
		
		var m, n, o;
	}
	
	public static function foo(value:String, cb:String->Void) {
		return cb( value );
	}
	
	public static function bar(value:String, cb1:String->String->Void, cb2:String->Void) {
		if (value == '') cb1( value, 'blank' ) else cb2( value );
	}
	
}