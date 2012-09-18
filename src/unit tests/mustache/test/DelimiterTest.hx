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
class DelimiterTest {
	
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
	 * Delimiter Tests
	 * -----
	 * https://github.com/mustache/spec/blob/master/specs/delimiters.yml
	 */
	
	@Test
	public function testPairBehavior():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/delimiters/pair_behavior.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/delimiters/pair_behavior.txt');
		output = mu.render(template, { text: 'Hey!' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testSpecialCharacters():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/delimiters/special_characters.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/delimiters/special_characters.txt');
		output = mu.render(template, { text: 'It worked!' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testDelimiterSections():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/delimiters/sections.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/delimiters/sections.txt');
		output = mu.render(template, { section: true, data: 'I got interpolated.' } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testDelimiterInvertedSections():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/delimiters/inverted_sections.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/delimiters/inverted_sections.txt');
		output = mu.render(template, { section: false, data: 'I got interpolated.' } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(expected.charAt(0));
		//trace(output.charAt(0));
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testDelimiterPartialInheritence():Void {
		Settings.TEMPLATE_PATH = 'resources/mu/spec/delimiters/';
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/delimiters/partial_inheritence.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/delimiters/partial_inheritence.txt');
		output = mu.render(template, { value: 'yes' } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testDelimiterPostPartial():Void {
		Settings.TEMPLATE_PATH = 'resources/mu/spec/delimiters/';
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/delimiters/post_partial.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/delimiters/post_partial.txt');
		output = mu.render(template, { value: 'yes' } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	/**
	 * Sub section - Whitespace Insensitivity
	 */
	
	@Test
	public function testDelimiterWhitespaceSensitivity():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/delimiters/whitespace_sensitivity.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/delimiters/whitespace_sensitivity.txt');
		output = mu.render(template, {  } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testDelimiterOutlyingWhitespace():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/delimiters/outlying_whitespace.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/delimiters/outlying_whitespace.txt');
		output = mu.render(template, {  } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testDelimiterStandaloneTag():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/delimiters/standalone_tag.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/delimiters/standalone_tag.txt');
		output = mu.render(template, {  } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testDelimiterIndentedStandaloneTag():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/delimiters/indented_standalone_tag.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/delimiters/indented_standalone_tag.txt');
		output = mu.render(template, {  } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testDelimiterStandaloneLineEndings():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/delimiters/standalone_line_endings.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/delimiters/standalone_line_endings.txt');
		output = mu.render(template, {  } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	@TestDebug
	public function testDelimiterStandaloneWithoutPreviousLine():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/delimiters/standalone_without_previous_line.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/delimiters/standalone_without_previous_line.txt');
		output = mu.render(template, {  } );
		//trace(expected.trim().replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.trim().replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testDelimiterStandaloneWithoutNewLine():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/delimiters/standalone_without_newline.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/delimiters/standalone_without_newline.txt');
		output = mu.render(template, {  } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	/**
	 * Sub section - Whitespace Insensitivity
	 */
	
	@Test
	public function testDelimiterPairWithPadding():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/delimiters/pair_with_padding.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/delimiters/pair_with_padding.txt');
		output = mu.render(template, {  } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
}