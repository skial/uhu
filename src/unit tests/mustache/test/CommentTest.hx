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
class CommentTest {
	
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
	 * Comment Tests
	 * -----
	 * https://github.com/mustache/spec/blob/master/specs/comments.yml
	 */
	
	@Test
	public function testInline():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/inline.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/inline.txt');
		output = mu.render(template, {} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testMultiline():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/multiline.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/multiline.txt');
		output = mu.render(template, {} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testStandalone():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/standalone.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/standalone.txt');
		output = mu.render(template, {} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testIndentedStandalone():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/indented_standalone.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/indented_standalone.txt');
		output = mu.render(template, {} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testStandaloneLineEnding():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/standalone_line_ending.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/standalone_line_ending.txt');
		output = mu.render(template, { } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testStandaloneWithoutPreviousLine():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/standalone_without_previous_line.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/standalone_without_previous_line.txt');
		output = mu.render(template, {} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testStandaloneWithoutNewLine():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/standalone_without_newline.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/standalone_without_newline.txt');
		output = mu.render(template, { } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testMultilineStandalone():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/multiline_standalone.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/multiline_standalone.txt');
		output = mu.render(template, {} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testIndentedMultilineStandalone():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/indented_multiline_standalone.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/indented_multiline_standalone.txt');
		output = mu.render(template, { } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testIndentedInline():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/indented_inline.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/indented_inline.txt');
		output = mu.render(template, {} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	//@TestDebug
	public function testSorroundingWhitespace():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/surrounding_whitespace.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/surrounding_whitespace.txt');
		output = mu.render(template, { } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		Assert.areEqual(expected.trim(), output.trim());
	}
	
}