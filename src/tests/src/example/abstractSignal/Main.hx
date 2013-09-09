package example.abstractSignal;

//import thx.react.Signal;

/**
 * ...
 * @author Skial Bainn
 */
class Main {

	public static function main() {
		var ssig1:Signal<String> = 'Hello world';
		var s:String = ssig1;
		var sig:thx.react.Signal.Signal1<String> = ssig1;
		
		sig.on( listen );
		
		var ssig2:Signal<String> = 'life, the universe and everything';
		
		ssig1 + ssig2;
	}
	
	public static function listen(value:String) {
		trace( value );
	}
	
}