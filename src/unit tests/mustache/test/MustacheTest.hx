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
class MustacheTest {
	
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
	
	@Test
	public function testNewline():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/newline.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/newline.html');
		output = mu.render(template, { name:"skial" } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testVariable():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/variables.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/variables.html');
		output = mu.render(template, { "name":"Chris", company:"<b>GitHub</b>" } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testSections():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/sections.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/sections.html');
		output = mu.render(template, { "person": true } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testNonEmptyLists():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/nonEmptyLists.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/nonEmptyLists.html');
		output = mu.render(template, { "repo": [
			{ "name": "resque" },
			{ "name": "hub" },
			{ "name": "rip" },
		] } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testMethods():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/methods.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/methods.html');
		output = mu.render(template, { "name": "Willy",
			"wrapped":function(text, render) {
				return "<b>" + render(text) + "</b>";
			}
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testNonFalse():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/nonFalse.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/nonFalse.html');
		output = mu.render(template, { "person?": { "name": "Jon" }	} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testInvertedSections():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/inverted.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/inverted.html');
		output = mu.render(template, { 
			t:true,
			f:false,
			two:'two',
			empty_list:[],
			populated_list:['some_value']
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testComments():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/comments.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/comments.html');
		output = mu.render(template, { title:'Today.'} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	@Ignore('Not part of the spec')
	public function testPartials():Void {
		Settings.TEMPLATE_PATH = 'resources/mu/';
		template = Library.loadTemplate('unit tests/mustache/resources/mu/partials.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/partials.html');
		output = mu.render(template, { names: [
			{ name:'Chris' },
			{ name:'Bob' }
		] } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testDelimiters():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/delimiters.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/delimiters.html');
		output = mu.render(template, { 
			first:'It worked the first time.', 
			second:'And it worked the second time.', 
			third:'Then, surprisingly, it worked the third time.' 
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testComplex():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/complex.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/complex.html');
		var items:Array<Dynamic> = [
				{ name:'red', current:true, url:'#Red' },
				{ name:'green', link:true, url:'#Green' },
				{ 'name':'blue', link:true, url:'#Blue' },
			];
		var empty = function() {
			return items.length == 0;
		}
		output = mu.render(template, { header:'Colors', 
			item:items,
			list:function() {
				return !empty();
			},
			empty:empty,
			empty_list:[]
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@Ignore('\\r\\n issue')
	//@TestDebug
	public function testDoubleSection():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/double_section.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/double_section.html');
		output = mu.render(template, { 
			t:true,
			two:'second',
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testEscape():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/escaped.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/escaped.html');
		output = mu.render(template, { 
			title:'Bear > Shark',
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testUnicodeOutput():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/unicodeOutput.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/unicodeOutput.html');
		output = mu.render(template, { 
			name:'Henri Poincaré',
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testTemplatePartial():Void {
		Settings.TEMPLATE_PATH = 'resources/mu/';
		template = Library.loadTemplate('unit tests/mustache/resources/mu/templatePartial.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/templatePartial.html');
		var title:String = 'Welcome';
		output = mu.render(template, { 
			title:title,
			title_bars:function() {
				var r = '';
				for (i in 0...title.length) {
					r += '-';
				}
				return r;
			},
			looping:[
				{item:'one' },
				{item:'two' },
				{item:'three'},
			],
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testAmpersandEscape():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/ampersand_escape.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/ampersand_escape.html');
		output = mu.render(template, { 
			message: "Some <code>",
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testApostrope():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/apostrophe.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/apostrophe.txt');
		output = mu.render(template, { 
			'apos': "'",
			'control': 'X',
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testArrayOfStrings():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/array_of_strings.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/array_of_strings.txt');
		output = mu.render(template, { 
			array_of_strings: ['hello', 'world']
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testBackSlashes():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/backslashes.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/backslashes.txt');
		output = mu.render(template, { 
			value: "\\abc"
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@Ignore('Following the mustache(5) spec, this is not allowed. Other ports allow this. I\'m still undecided.')
	//@Ignore
	public function testContextLookup():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/context_lookup.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/context_lookup.txt');
		output = mu.render(template, { 
			"outer": {
				"id": 1,
				"second": {
					"nothing": 2
				}
			}
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testUnescaped():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/unescaped.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/unescaped.txt');
		output = mu.render(template, { 
			title: "Bear > Shark",
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testDisappearingWhitespace():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/disappearing_whitespace.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/disappearing_whitespace.txt');
		output = mu.render(template, { 
			bedrooms: true,
			total: 1
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testDoubleRender():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/double_render.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/double_render.txt');
		output = mu.render(template, { 
			foo: true,
			bar: "{{win}}",
			win: "FAIL"
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
}