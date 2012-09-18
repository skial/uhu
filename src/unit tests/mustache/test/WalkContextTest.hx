package ;

import uhu.mu.Common;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import uhu.mu.Renderer;
import uhu.mu.Settings;
import Mustache;
import uhu.Library;

using StringTools;


/**
* Auto generated MassiveUnit Test Class 
*/
class WalkContextTest {
	
	public var mu:Mustache;
	public var output:String;
	public var expected:String;
	public var template:String;
	
	public function new() {
		
	}
	
	@BeforeClass
	public function beforeClass():Void {
		mu = new Mustache();
	}
	
	@AfterClass
	public function afterClass():Void {
		
	}
	
	@Before
	public function setup():Void {
		Settings.TEMPLATE_PATH = '';
		output = '';
		expected = '';
		template = '';
	}
	
	@After
	public function tearDown():Void {
		
	}
	
	/**
	 * Mustache Render Method Tests
	 * -----
	 */
	
	@Test
	public function testWalkContextSingle():Void {
		var r = new Renderer();
		var o = { name:'skial' };
		Assert.areEqual('skial', r._walkContext('name', [o]));
	}
	
	@Test
	public function testWalkContextMulti():Void {
		var r = new Renderer();
		var o = { a:1, b:'hello', c:'66', d:[1, 2, 3] };
		Assert.areEqual(o.d, r._walkContext('d', [o]));
	}
	
	@Test
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
		Assert.areEqual(o.d.cc.aaa, r._walkContext('aaa', [o]));
	}
	
	@Test
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
		Assert.areEqual(o.d[0].cc.aaa, r._walkContext('aaa', [o]));
	}
	
	@Test
	public function testWalkContextMultiArray():Void {
		var r = new Renderer();
		var o = { a:1, b:'hello', c:'66', d: [{ 
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
		Assert.areEqual(o.d[1].hello, r._walkContext('hello', [o]));
	}
	
	@Test
	public function testWalkContextMultiArrayDeep():Void {
		var r = new Renderer();
		var o = { a:1, b:'hello', c:'66', d: [{ 
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
		Assert.areEqual(o.d[1].a.c.d.three, r._walkContext('three', [o]));
	}
	
}