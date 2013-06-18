package uhu.mu;

import haxe.unit.TestCase;
//import uhu.mu.Renderer;
//import uhu.mu.Settings;
//import uhu.mu.Common;
import uhu.Library;
import Mustache;
import utest.Assert;

using StringTools;


/**
* Auto generated MassiveUnit Test Class 
*/
class MustacheSpec extends TestCase {
	
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
	
	public function testNewline():Void {
		template = Library.loadTemplate('resources/mu/newline.mustache');
		expected = Library.loadTemplate('templates/html/newline.html');
		output = mu.render(template, [ 'name'=>"skial" ] );
		Assert.equals(expected, output);
	}
	
	public function testVariable():Void {
		template = Library.loadTemplate('resources/mu/variables.mustache');
		expected = Library.loadTemplate('templates/html/variables.html');
		output = mu.render(template, [ 'name'=>"Chris", 'company'=>"<b>GitHub</b>" ] );
		Assert.equals(expected, output);
	}
	
	public function testSections():Void {
		template = Library.loadTemplate('resources/mu/sections.mustache');
		expected = Library.loadTemplate('templates/html/sections.html');
		output = mu.render(template, [ "person"=> true ] );
		Assert.equals(expected, output);
	}
	
	/*public function testNonEmptyLists():Void {
		template = Library.loadTemplate('resources/mu/nonEmptyLists.mustache');
		expected = Library.loadTemplate('templates/html/nonEmptyLists.html');
		output = mu.render(template, [ "repo" => [
			[ "name"=> "resque"],
			[ "name"=> "hub" ],
			[ "name"=> "rip" ],
		] ] );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testMethods():Void {
		template = Library.loadTemplate('resources/mu/methods.mustache');
		expected = Library.loadTemplate('templates/html/methods.html');
		output = mu.render(template, [ "name"=> "Willy",
			"wrapped"=>function(text, render) {
				return "<b>" + render(text) + "</b>";
			}
		] );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testNonFalse():Void {
		template = Library.loadTemplate('resources/mu/nonFalse.mustache');
		expected = Library.loadTemplate('templates/html/nonFalse.html');
		output = mu.render(template, [ "person?"=> [ "name"=> "Jon" ] ] );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testInvertedSections():Void {
		template = Library.loadTemplate('resources/mu/inverted.mustache');
		expected = Library.loadTemplate('templates/html/inverted.html');
		output = mu.render(template, [ 
			't'=>true,
			'f'=>false,
			'two'=>'two',
			'empty_list'=>[],
			'populated_list'=>['some_value']
		] );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testComments():Void {
		template = Library.loadTemplate('resources/mu/comments.mustache');
		expected = Library.loadTemplate('templates/html/comments.html');
		//output = mu.render(template, { title:'Today.'} );
		output = mu.render(template, [ 'title'=>'Today.'] );
		assertEquals(expected.trim(), output.trim());
	}*/
	
	/*@Ignore('Not part of the spec')
	public function testPartials():Void {
		Settings.TEMPLATE_PATH = '../resources/mu/';
		template = Library.loadTemplate('resources/mu/partials.mustache');
		expected = Library.loadTemplate('templates/html/partials.html');
		output = mu.render(template, { names: [
			{ name:'Chris' },
			{ name:'Bob' }
		] } );
		assertEquals(expected.trim(), output.trim());
	}*/
	
	/*public function testDelimiters():Void {
		template = Library.loadTemplate('resources/mu/delimiters.mustache');
		expected = Library.loadTemplate('templates/html/delimiters.html');
		output = mu.render(template, [ 
			'first'=>'It worked the first time.', 
			'second'=>'And it worked the second time.', 
			'third'=>'Then, surprisingly, it worked the third time.' 
		] );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testComplex():Void {
		template = Library.loadTemplate('resources/mu/complex.mustache');
		expected = Library.loadTemplate('templates/html/complex.html');
		var items:Array<Map<String,Dynamic>> = [
			[ 'name'=>'red', 'current'=>true, 'url'=>'#Red' ],
			[ 'name'=>'green', 'link'=>true, 'url'=>'#Green' ],
			[ 'name'=>'blue', 'link'=>true, 'url'=>'#Blue' ],
		];
		var empty = function() {
			return items.length == 0;
		}
		output = mu.render(template, [ 'header'=>'Colors', 
			'item'=>items,
			'list'=>function() {
				return !empty();
			},
			'empty'=>empty,
			'empty_list'=>[]
		] );
		assertEquals(expected.trim(), output.trim());
	}
	
	//@Ignore('\\r\\n issue')
	public function testDoubleSection():Void {
		template = Library.loadTemplate('resources/mu/double_section.mustache');
		expected = Library.loadTemplate('templates/html/double_section.html');
		output = mu.render(template, [ 
			't'=>true,
			'two'=>'second',
		] );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testEscape():Void {
		template = Library.loadTemplate('resources/mu/escaped.mustache');
		expected = Library.loadTemplate('templates/html/escaped.html');
		output = mu.render(template, [ 
			'title'=>'Bear > Shark',
		] );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testUnicodeOutput():Void {
		template = Library.loadTemplate('resources/mu/unicodeOutput.mustache');
		expected = Library.loadTemplate('templates/html/unicodeOutput.html');
		output = mu.render(template, [ 
			'name'=>'Henri Poincaré',
		] );
		assertEquals(expected.trim(), output.trim());
	}*/
	
	/*public function testTemplatePartial():Void {
		Settings.TEMPLATE_PATH = '../resources/mu/';
		template = Library.loadTemplate('resources/mu/templatePartial.mustache');
		expected = Library.loadTemplate('templates/html/templatePartial.html');
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
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testAmpersandEscape():Void {
		template = Library.loadTemplate('resources/mu/ampersand_escape.mustache');
		expected = Library.loadTemplate('templates/html/ampersand_escape.html');
		output = mu.render(template, { 
			message: "Some <code>",
		} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testApostrope():Void {
		template = Library.loadTemplate('resources/mu/apostrophe.mustache');
		expected = Library.loadTemplate('templates/html/apostrophe.txt');
		output = mu.render(template, { 
			'apos': "'",
			'control': 'X',
		} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testArrayOfStrings():Void {
		template = Library.loadTemplate('resources/mu/array_of_strings.mustache');
		expected = Library.loadTemplate('templates/html/array_of_strings.txt');
		output = mu.render(template, { 
			array_of_strings: ['hello', 'world']
		} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testBackSlashes():Void {
		template = Library.loadTemplate('resources/mu/backslashes.mustache');
		expected = Library.loadTemplate('templates/html/backslashes.txt');
		output = mu.render(template, { 
			value: "\\abc"
		} );
		assertEquals(expected.trim(), output.trim());
	}
	
	//@Ignore('Following the mustache(5) spec, this is not allowed. Other ports allow this. I\'m still undecided.')
	public function testContextLookup():Void {
		template = Library.loadTemplate('resources/mu/context_lookup.mustache');
		expected = Library.loadTemplate('templates/html/context_lookup.txt');
		output = mu.render(template, { 
			"outer": {
				"id": 1,
				"second": {
					"nothing": 2
				}
			}
		} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testUnescaped():Void {
		template = Library.loadTemplate('resources/mu/unescaped.mustache');
		expected = Library.loadTemplate('templates/html/unescaped.txt');
		output = mu.render(template, { 
			title: "Bear > Shark",
		} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDisappearingWhitespace():Void {
		template = Library.loadTemplate('resources/mu/disappearing_whitespace.mustache');
		expected = Library.loadTemplate('templates/html/disappearing_whitespace.txt');
		output = mu.render(template, { 
			bedrooms: true,
			total: 1
		} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDoubleRender():Void {
		template = Library.loadTemplate('resources/mu/double_render.mustache');
		expected = Library.loadTemplate('templates/html/double_render.txt');
		output = mu.render(template, { 
			foo: true,
			bar: "{{win}}",
			win: "FAIL"
		} );
		assertEquals(expected.trim(), output.trim());
	}*/
	
}