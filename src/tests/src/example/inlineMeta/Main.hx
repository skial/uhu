package example.inlineMeta;

/**
 * ...
 * @author Skial Bainn
 */
@:build( example.inlineMeta.Macro.build() )
class Main {
	
	public static function main() {
		
		var time = 1000;
		var results = [ 0.0 ];
		
		js.Browser.window.setTimeout(function() {
			results.push( 1.0 );
			trace( results );
			
			js.Browser.window.setTimeout(function() {
				results.push( 2.0 );
				trace( results );
			}, time);
			
		}, time);
		
		// Now the reduced version
		var results = [ 0.0 ];
		
		@:wait([]) js.Browser.window.setTimeout(_, time);
		
		results.push( -1.0 );
		trace( results );
		
		@:wait js.Browser.window.setTimeout([], time);
		
		results.push( -2.0 );
		trace( results );
		
	}
	
}