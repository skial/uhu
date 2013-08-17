package uhx.sys;

import utest.Assert;

/**
 * ...
 * @author Skial Bainn
 */
class EdeSpec {

	public function new() {
		
	}
	
	public function testNotEnoughArgs() {
		Assert.raises( function() {
			var peep = new Person( ['-r', 'a', 'b'] );
		} );
	}
	
	public function testFields() {
		var peep = new Person( ['-a', '25', '--name', 'Skial Bainn', '-l', '4'] );
		
		Assert.equals(25, peep.age);
		Assert.is(peep.age, Int);
		Assert.equals('Skial Bainn', peep.name);
		Assert.equals(4, peep.limbs);
	}
	
	public function testHelp() {
		var peep = new Person( ['-h'] );
		
		var h = peep.help();
		Assert.is(h, String);
	}
	
}

/**
 * An undefined Person
 */
@:cmd
@:usage('person [options]')
class Person implements Klas {
	
	/**
	 * The persons age.
	 */
	@alias('a')
	public var age:Int;
	
	/**
	 * The persons full name.
	 */
	@alias('n')
	public var name:String;
	
	/**
	 * How many limbs the person has.
	 */
	@alias('l')
	public function numLimbs(v:Int) {
		limbs = v;
	}
	
	public var limbs:Int;
	
	/**
	 * Does nothing.
	 */
	public function r(a:String, b:String, c:Int) {
		// nothing
	}
	
	public function new(args:Array<String>) {
		
	}
	
}