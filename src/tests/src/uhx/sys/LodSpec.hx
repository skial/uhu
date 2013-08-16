package uhx.sys;

import haxe.ds.StringMap;
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
		
		var map:StringMap<Array<Dynamic>> = l.parse();
		
		Assert.equals('1', map.get('a')[0]);
		Assert.equals('2', map.get('b')[0]);
		Assert.equals('false', map.get('c')[0]);
		Assert.equals(l.args, map.get('original'));
	}
	
	public function testArgv() {
		var l = new Lod();
		l.args = ['--a', '1', '--', '-b', '2', '--no-c'];
		
		var map = l.parse();
		
		Assert.equals('1', map.get('a')[0]);
		Assert.equals('' + ['-b', '2', '--no-c'], '' + map.get('argv'));
	}
	
	public function testSeperator() {
		var l = new Lod();
		l.seperator = '=';
		l.args = ['-a=1', '-b=2', '-c="Hello World"', "-d='Hello Skial'"];
		
		var map = l.parse();
		
		Assert.equals('1', map.get('a')[0]);
		Assert.equals('2', map.get('b')[0]);
		Assert.equals('Hello World', map.get('c')[0]);
		Assert.equals('Hello Skial', map.get('d')[0]);
	}
	
}