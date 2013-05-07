package help.metadata.pubsub;

/**
 * ...
 * @author Skial Bainn
 */
class A implements Klas {
	
	@:sub('help.metadata.pubsub.B._b') public static var _a:Int;

	@:sub('help.metadata.pubsub.B::b') public var a:String;
	
	@:sub('help.metadata.pubsub.B::c') public var c: { name:String };
	
	@:sub('help.metadata.pubsub.B::middle') public var end:String;
	
	public function new() {
		
	}
	
}