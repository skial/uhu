package uhu.mu;

import haxe.unit.TestCase;
import uhu.mu.Renderer;
import uhu.mu.Settings;
import uhu.mu.Common;
import uhu.Library;
import Mustache;

using StringTools;


/**
* Auto generated MassiveUnit Test Class 
*/
class CommentSpec extends TestCase {
	
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
	 * Comment Tests
	 * -----
	 * https://github.com/mustache/spec/blob/master/specs/comments.yml
	 */
	
	public function testInline():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/inline.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/inline.txt');
		output = mu.render(template, {} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testMultiline():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/multiline.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/multiline.txt');
		output = mu.render(template, {} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testStandalone():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/standalone.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/standalone.txt');
		output = mu.render(template, {} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testIndentedStandalone():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/indented_standalone.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/indented_standalone.txt');
		output = mu.render(template, {} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testStandaloneLineEnding():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/standalone_line_ending.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/standalone_line_ending.txt');
		output = mu.render(template, { } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testStandaloneWithoutPreviousLine():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/standalone_without_previous_line.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/standalone_without_previous_line.txt');
		output = mu.render(template, {} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testStandaloneWithoutNewLine():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/standalone_without_newline.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/standalone_without_newline.txt');
		output = mu.render(template, { } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testMultilineStandalone():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/multiline_standalone.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/multiline_standalone.txt');
		output = mu.render(template, {} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testIndentedMultilineStandalone():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/indented_multiline_standalone.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/indented_multiline_standalone.txt');
		output = mu.render(template, { } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testIndentedInline():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/indented_inline.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/indented_inline.txt');
		output = mu.render(template, {} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testSorroundingWhitespace():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/comments/surrounding_whitespace.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/comments/surrounding_whitespace.txt');
		output = mu.render(template, { } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		assertEquals(expected.trim(), output.trim());
	}
	
}