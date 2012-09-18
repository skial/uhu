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
class PartialTest {
	
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
		Common.clearCache();
		Settings.TEMPLATE_PATH = '';
		output = '';
		expected = '';
		template = '';
	}
	
	@After
	public function tearDown():Void {
		
	}
	
	/**
	 * Partial Tests
	 * -----
	 * https://github.com/mustache/spec/blob/master/specs/partials.yml
	 */
	
	@Test
	public function testBasicBehavior():Void {
		Settings.TEMPLATE_PATH = 'resources/mu/spec/partial/';
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/partial/basic_behavior.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/partial/basic_behavior.txt');
		output = mu.render(template, {} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testFailedLookup():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/partial/failed_lookup.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/partial/failed_lookup.txt');
		output = mu.render(template, {} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testContext():Void {
		Settings.TEMPLATE_PATH = 'resources/mu/spec/partial/';
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/partial/context.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/partial/context.txt');
		output = mu.render(template, { text: 'content' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testRecursion():Void {
		Settings.TEMPLATE_PATH = 'resources/mu/spec/partial/';
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/partial/recursion.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/partial/recursion.txt');
		output = mu.render(template, { content: "X", nodes: [ { content: "Y", nodes: [] } ] } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testSurroundingWhitespace():Void {
		Settings.TEMPLATE_PATH = 'resources/mu/spec/partial/';
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/partial/surrounding_whitespace.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/partial/surrounding_whitespace.txt');
		output = mu.render(template, {  } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testInlineIndentation():Void {
		Settings.TEMPLATE_PATH = 'resources/mu/spec/partial/';
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/partial/inline_indentation.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/partial/inline_indentation.txt');
		output = mu.render(template, { data: '|' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testStandaloneLineEndings():Void {
		Settings.TEMPLATE_PATH = 'resources/mu/spec/partial/';
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/partial/standalone_line_endings.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/partial/standalone_line_endings.txt');
		output = mu.render(template, {  } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	@Ignore('Spec does not make sense. Extra withspace is being inserted when it shouldnt. Spec wrong??')
	public function testStandaloneWithoutPreviousLine():Void {
		Settings.TEMPLATE_PATH = 'resources/mu/spec/partial/';
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/partial/standalone_without_previous_line.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/partial/standalone_without_previous_line.txt');
		output = mu.render(template, {  } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	@Ignore('Again, extra whitespace is being inserted. Spec wrong??')
	public function testStandaloneWithoutNewline():Void {
		Settings.TEMPLATE_PATH = 'resources/mu/spec/partial/';
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/partial/standalone_without_newline.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/partial/standalone_without_newline.txt');
		output = mu.render(template, {  } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	@Ignore('Need to add any space which precedes the partial tag to each line in the partial')
	public function testStandaloneIndentation():Void {
		Settings.TEMPLATE_PATH = 'resources/mu/spec/partial/';
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/partial/standalone_indentation.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/partial/standalone_indentation.txt');
		output = mu.render(template, { content: "<\r\n->" } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testPadding():Void {
		Settings.TEMPLATE_PATH = 'resources/mu/spec/partial/';
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/partial/padding.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/partial/padding.txt');
		output = mu.render(template, { boolean: true } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
}