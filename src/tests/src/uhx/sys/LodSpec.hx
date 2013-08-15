package uhx.sys;

import utest.Assert;

/**
 * ...
 * @author Skial Bainn
 */
class LodSpec {

	public function new() {
		
	}
	
	public function testArgs() {
		var l = new Lod();
		l.args = ['--a', '1', '-b', '2', '--no-c'];
		
		var map = l.parse();
		
		Assert.equals('1', map.get('a'));
		Assert.equals('2', map.get('b'));
		Assert.equals('false', map.get('c'));
		Assert.equals(l.args, map.get('original'));
	}
	
	public function testArgv() {
		var l = new Lod();
		l.args = ['--a', '1', '--', '-b', '2', '--no-c'];
		
		var map = l.parse();
		
		Assert.equals('1', map.get('a'));
		Assert.equals(''+['-b', '2', '--no-c'], ''+map.get('argv'));
	}
	
}