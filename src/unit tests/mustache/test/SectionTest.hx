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
class SectionTest {
	
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
	 * Section Tests
	 * -----
	 * https://github.com/mustache/spec/blob/master/specs/sections.yml
	 */
	
	@Test
	public function testTruthy():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/truthy.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/truthy.txt');
		output = mu.render(template, { boolean: true } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testFalsey():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/falsey.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/falsey.txt');
		output = mu.render(template, { boolean: false } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testSectionContext():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/context.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/context.txt');
		output = mu.render(template, { context: { name: 'Joe' } } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@Ignore('If you replace \\r\\n from previous tag, you will break 3 other tests. Need to rewrite more than one section case.')
	public function testDeepContext():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/deep_context.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/deep_context.txt');
		output = mu.render(template, { a: { one: 1 },
			b: { two: 2 },
			c: { three: 3 },
			d: { four: 4 },
			e: { five: 5 } 
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testList():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/list.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/list.txt');
		output = mu.render(template, { list: [ { item: 1 }, { item: 2 }, { item: 3 } ] } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testEmptyList():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/emptyList.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/emptyList.txt');
		output = mu.render(template, { list: [ ] } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@Ignore('\\r\\n issue')
	//@TestDebug
	public function testDoubled():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/doubled.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/doubled.txt');
		output = mu.render(template, { bool: true, two: 'second' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testNestedTruthy():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/nested_truthy.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/nested_truthy.txt');
		output = mu.render(template, { bool: true } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testNestedFalsey():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/nested_falsey.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/nested_falsey.txt');
		output = mu.render(template, { bool: false } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testContextMisses():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/context_misses.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/context_misses.txt');
		output = mu.render(template, { } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	/**
	 * Sub section - Implicit Iterators
	 */
	
	@Test
	public function testImplicitString():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/implicit_string.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/implicit_string.txt');
		output = mu.render(template, { list: [ 'a', 'b', 'c', 'd', 'e' ] } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testImplicitInteger():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/implicit_integer.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/implicit_integer.txt');
		output = mu.render(template, { list: [ 1, 2, 3, 4, 5 ] } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testImplicitDecimal():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/implicit_decimal.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/implicit_decimal.txt');
		output = mu.render(template, { list: [ 1.10, 2.20, 3.30, 4.40, 5.50 ] } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	/**
	 * Sub section - Dotted Names
	 */
	
	@Test
	public function testDottedTruthy():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/dotted_truthy.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/dotted_truthy.txt');
		output = mu.render(template, { a: { b: { c: true } } } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testDottedFalsey():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/dotted_falsey.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/dotted_falsey.txt');
		output = mu.render(template, { a: { } } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	/**
	 * Sub section - Whitespace Sensitivity
	 */
	
	@Test
	public function testSurroundingWhitespace():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/surrounding_whitespace.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/surrounding_whitespace.txt');
		output = mu.render(template, { boolean: true } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testInternalWhitespace():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/internal_whitespace.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/internal_whitespace.txt');
		output = mu.render(template, { boolean: true } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testIndentedInlineWhitespace():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/iindented_inline_whitespace.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/iindented_inline_whitespace.txt');
		output = mu.render(template, { boolean: true } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	//@Ignore('Standalone lines should be removed from the template.')
	public function testStandaloneLines():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/standalone_whitespace.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/standalone_whitespace.txt');
		output = mu.render(template, { boolean: true } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@Ignore('Indented standalone lines should be removed from the template.')
	//@TestDebug
	public function testIndentedStandaloneLines():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/indented_standalone_lines.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/indented_standalone_lines.txt');
		output = mu.render(template, { boolean: true } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	//@Ignore('"\r\n" should be considered a newline for standalone tags.')
	public function testStandaloneLineEndings():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/standalone_line_endings.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/standalone_line_endings.txt');
		output = mu.render(template, { boolean: true } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	//@Ignore('Standalone tags should not require a newline to precede them.')
	public function testSectionStandaloneWithoutPreviousLine():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/standalone_without_previous_line.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/standalone_without_previous_line.txt');
		output = mu.render(template, { boolean: true } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	//@Ignore('Standalone tags should not require a newline to follow them.')
	public function testStandaloneWithoutNewline():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/standalone_without_newline.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/standalone_without_newline.txt');
		output = mu.render(template, { boolean: true } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	/**
	 * Sub section - Whitespace Insensitivity
	 */
	
	@Test
	public function testPadding():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/sections/padding.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/sections/padding.txt');
		output = mu.render(template, { boolean: true } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
}