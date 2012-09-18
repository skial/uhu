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
class InvertedTest {
	
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
	 * Inverted Spec
	 * -----
	 * https://github.com/mustache/spec/blob/master/specs/inverted.yml
	 */
	
	@Test
	public function testFalsey():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/falsey.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/falsey.txt');
		output = mu.render(template, { boolean: false } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testTruthy():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/truthy.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/truthy.txt');
		output = mu.render(template, { boolean: true } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testContext():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/context.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/context.txt');
		output = mu.render(template, { context: { name: 'Joe' } } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testList():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/list.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/list.txt');
		output = mu.render(template, { list: [ { n: 1 }, { n: 2 }, { n: 3 } ] } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testEmptyList():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/empty_list.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/empty_list.txt');
		output = mu.render(template, { list: [  ] } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testDoubled():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/doubled.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/doubled.txt');
		output = mu.render(template, { bool: false, two: 'second' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testNestedFalsey():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/nested_falsey.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/nested_falsey.txt');
		output = mu.render(template, { bool: false } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testNestedTruthy():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/nested_truthy.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/nested_truthy.txt');
		output = mu.render(template, { bool: true } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testContextMisses():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/context_misses.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/context_misses.txt');
		output = mu.render(template, {} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testDottedNamesTruthy():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/dotted_names_truthy.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/dotted_names_truthy.txt');
		output = mu.render(template, { a: { b: { c: true } } } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testDottedNamesFalsey():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/dotted_names_falsey.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/dotted_names_falsey.txt');
		output = mu.render(template, { a: { b: { c: false } } } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testDottedNamesBrokenChains():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/dotted_names_broken_chains.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/dotted_names_broken_chains.txt');
		output = mu.render(template, { a: { b: { c: false } } } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testSurroundingWhitespace():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/surrounding_whitespace.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/surrounding_whitespace.txt');
		output = mu.render(template, { boolean: false } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testInternalWhitespace():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/internal_whitespace.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/internal_whitespace.txt');
		output = mu.render(template, { boolean: false } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testIndentedInlineSection():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/indented_inline_section.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/indented_inline_section.txt');
		output = mu.render(template, { boolean: false } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testStandaloneLines():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/standalone_lines.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/standalone_lines.txt');
		output = mu.render(template, { boolean: false } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testStandaloneIndentedLines():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/standalone_indented_lines.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/standalone_indented_lines.txt');
		output = mu.render(template, { boolean: false } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testStandaloneLinesEndings():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/standalone_lines_endings.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/standalone_lines_endings.txt');
		output = mu.render(template, { boolean: false } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testStandaloneWithoutPreviousLine():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/standalone_without_previous_line.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/standalone_without_previous_line.txt');
		output = mu.render(template, { boolean: false } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testStandaloneWithoutNewLine():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/standalone_without_newline.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/standalone_without_newline.txt');
		output = mu.render(template, { boolean: false } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testPadding():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/inverted/padding.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/inverted/padding.txt');
		output = mu.render(template, { boolean: false } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
}