package help.metadata.pubsub;

/**
 * ...
 * @author Skial Bainn
 */
class A implements Klas {
	
	@:sub('help.metadata.pubsub.B._b') public static var _a:Int;

	@:sub('help.metadata.pubsub.B::b') public var a:String;
	
	@:sub('help.metadata.pubsub.B::c') public var c: { name:String, a:Int, b:Int };
	
	@:sub('help.metadata.pubsub.B::middle') public var end:String;
	
	@:sub('help.metadata.pubsub.B._middle') public static var _end:String;
	
	@:sub('help.metadata.pubsub.B._middle') public var fin:String;
	
	public function new() {
		
	}
	
}