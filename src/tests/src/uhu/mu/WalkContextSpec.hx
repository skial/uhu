package uhu.mu;

import haxe.unit.TestCase;
//import uhu.mu.Renderer;
import uhu.mu.Settings;
import uhu.mu.Common;
import uhu.Library;
import Mustache;

using StringTools;


/**
* Auto generated MassiveUnit Test Class 
*/
class WalkContextSpec extends TestCase {
	
	public var mu:Mustache;
	public var output:String;
	public var expected:String;
	public var template:String;
	
	public function new() {
		super();
	}
	
	override public function setup():Void {
		mu = new Mustache();
		Settings.TEMPLATE_PATH = '';
		output = '';
		expected = '';
		template = '';
	}
	
	/**
	 * Mustache Render Method Tests
	 * -----
	 */
	
	public function testWalkContextSingle():Void {
		var r = new Renderer();
		var o = { name:'skial' };
		assertEquals('skial', r._walkContext('name', [o]));
	}
	
	public function testWalkContextMulti():Void {
		var r = new Renderer();
		var o = { a:1, b:'hello', c:'66', d:[1, 2, 3] };
		assertEquals(o.d, r._walkContext('d', [o]));
	}
	
	public function testWalkContextObjectDeep():Void {
		var r = new Renderer();
		var o = { a:1, b:'hello', c:'66', d: { 
			aa:'world',
			bb:'skial',
			cc: {
				aaa:111,
				bbb:'haxe'
			},
			ddd:0
		} };
		assertEquals(o.d.cc.aaa, r._walkContext('aaa', [o]));
	}
	
	public function testWalkContextSingleArray():Void {
		var r = new Renderer();
		var o = { a:1, b:'hello', c:'66', d: [{ 
			aa:'world',
			bb:'skial',
			cc: {
				aaa:111,
				bbb:'haxe'
			},
			ddd:0
		}] };
		assertEquals(o.d[0].cc.aaa, r._walkContext('aaa', [o]));
	}
	
	public function testWalkContextMultiArray():Void {
		var r = new Renderer();
		var o:{a:Int, b:String, c:String, d:Array<Dynamic>} = { a:1, b:'hello', c:'66', d: [{ 
			aa:'world',
			bb:'skial',
			cc: {
				aaa:111,
				bbb:'haxe'
			},
			ddd:0
		},
		{
			hello:'world'
		}] };
		assertEquals(o.d[1].hello, r._walkContext('hello', [o]));
	}
	
	public function testWalkContextMultiArrayDeep():Void {
		var r = new Renderer();
		var o:{a:Int, b:String, c:String, d:Array<Dynamic>} = { a:1, b:'hello', c:'66', d: [{ 
			aa:'world',
			bb:'skial',
			cc: {
				aaa:111,
				bbb:'haxe'
			},
			ddd:0
		},
		{
			a: {
				b: {
					hello:'world'
				},
				c: {
					d: {
						one:1,
						two:2,
						three:3
					}
				}
			}
		}] };
		assertEquals(o.d[1].a.c.d.three, r._walkContext('three', [o]));
	}
	
}