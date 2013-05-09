package help.metadata.pubsub;

/**
 * ...
 * @author Skial Bainn
 */
class B implements Klas {
	
	@:pub public static var _b:Int;
	
	@:pub public var b:String;
	
	@:pub public var c: { name:String };
	
	@:pub 
	@:sub('help.metadata.pubsub.C::start') 
	public var middle:String;
	
	@:pub 
	@:sub('help.metadata.pubsub.C._start')
	@:sub('help.metadata.pubsub.C::commencer')
	public static var _middle:String;

	public function new() {
		
	}
	
}