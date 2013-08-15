package help.metadata.pubsub;

/**
 * ...
 * @author Skial Bainn
 */
class A implements Klas {
	
	// subscribing to static variable `_b`
	@:sub(help.metadata.pubsub.B._b, ns='aa') public static var _a:Int;

	// subscribing to an instance variable `b`
	@:sub(help.metadata.pubsub.B,b) public var a:String;
	
	// subscribing to an instance variable `c`
	@:sub(help.metadata.pubsub.B,c) public var c: { name:String, a:Int, b:Int };
	
	// subscribing to an instance variable `middle`
	@:sub(help.metadata.pubsub.B,middle) public var end:String;
	
	// subscribing to static variable `_middle`
	@:sub(help.metadata.pubsub.B._middle) public static var _end:String;
	
	// subscribing to static variable `_middle`
	@:sub(help.metadata.pubsub.B._middle) public var fin:String;
	
	public function new() {
		
	}
	
}