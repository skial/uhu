package uhx.macro;

/**
 * Kort - The extendable, all encompassing minifier/optimiser
 */
@:cmd
@:usage('kort [options] <file>')
class Kort implements Klas {
	
	/**
	 * <file> Pass a user defined configuration file to kort
	 */
	@alias('c')
	public var config:String;
	
	public function new(args:Array<String>) {
		
	}
	
	/**
	 * Setup the location of the core programs
	 */
	@alias('s')
	public function setup(args:Array<String>) {
		
	}
	
}