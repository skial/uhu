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
class DelimiterSpec extends TestCase {
	
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
	 * Delimiter Tests
	 * -----
	 * https://github.com/mustache/spec/blob/master/specs/delimiters.yml
	 */
	
	public function testPairBehavior():Void {
		template = Library.loadTemplate('resources/mu/spec/delimiters/pair_behavior.mustache');
		expected = Library.loadTemplate('templates/html/spec/delimiters/pair_behavior.txt');
		output = mu.render(template, { text: 'Hey!' } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testSpecialCharacters():Void {
		template = Library.loadTemplate('resources/mu/spec/delimiters/special_characters.mustache');
		expected = Library.loadTemplate('templates/html/spec/delimiters/special_characters.txt');
		output = mu.render(template, { text: 'It worked!' } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDelimiterSections():Void {
		template = Library.loadTemplate('resources/mu/spec/delimiters/sections.mustache');
		expected = Library.loadTemplate('templates/html/spec/delimiters/sections.txt');
		output = mu.render(template, { section: true, data: 'I got interpolated.' } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDelimiterInvertedSections():Void {
		template = Library.loadTemplate('resources/mu/spec/delimiters/inverted_sections.mustache');
		expected = Library.loadTemplate('templates/html/spec/delimiters/inverted_sections.txt');
		output = mu.render(template, { section: false, data: 'I got interpolated.' } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(expected.charAt(0));
		//trace(output.charAt(0));
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDelimiterPartialInheritence():Void {
		Settings.TEMPLATE_PATH = '../resources/mu/spec/delimiters/';
		template = Library.loadTemplate('resources/mu/spec/delimiters/partial_inheritence.mustache');
		expected = Library.loadTemplate('templates/html/spec/delimiters/partial_inheritence.txt');
		output = mu.render(template, { value: 'yes' } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDelimiterPostPartial():Void {
		Settings.TEMPLATE_PATH = '../resources/mu/spec/delimiters/';
		template = Library.loadTemplate('resources/mu/spec/delimiters/post_partial.mustache');
		expected = Library.loadTemplate('templates/html/spec/delimiters/post_partial.txt');
		output = mu.render(template, { value: 'yes' } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		assertEquals(expected.trim(), output.trim());
	}
	
	/**
	 * Sub section - Whitespace Insensitivity
	 */
	
	public function testDelimiterWhitespaceSensitivity():Void {
		template = Library.loadTemplate('resources/mu/spec/delimiters/whitespace_sensitivity.mustache');
		expected = Library.loadTemplate('templates/html/spec/delimiters/whitespace_sensitivity.txt');
		output = mu.render(template, {  } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDelimiterOutlyingWhitespace():Void {
		template = Library.loadTemplate('resources/mu/spec/delimiters/outlying_whitespace.mustache');
		expected = Library.loadTemplate('templates/html/spec/delimiters/outlying_whitespace.txt');
		output = mu.render(template, {  } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDelimiterStandaloneTag():Void {
		template = Library.loadTemplate('resources/mu/spec/delimiters/standalone_tag.mustache');
		expected = Library.loadTemplate('templates/html/spec/delimiters/standalone_tag.txt');
		output = mu.render(template, {  } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDelimiterIndentedStandaloneTag():Void {
		template = Library.loadTemplate('resources/mu/spec/delimiters/indented_standalone_tag.mustache');
		expected = Library.loadTemplate('templates/html/spec/delimiters/indented_standalone_tag.txt');
		output = mu.render(template, {  } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDelimiterStandaloneLineEndings():Void {
		template = Library.loadTemplate('resources/mu/spec/delimiters/standalone_line_endings.mustache');
		expected = Library.loadTemplate('templates/html/spec/delimiters/standalone_line_endings.txt');
		output = mu.render(template, {  } );
		assertEquals(expected.trim(), output.trim());
	}
	
	/*@Ignore('Need to check why a newline is being added to the end')
	public function testDelimiterStandaloneWithoutPreviousLine():Void {
		template = Library.loadTemplate('resources/mu/spec/delimiters/standalone_without_previous_line.mustache');
		expected = Library.loadTemplate('templates/html/spec/delimiters/standalone_without_previous_line.txt');
		output = mu.render(template, {  } );
		//trace(expected.trim().replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.trim().replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		assertEquals(expected.trim(), output.trim());
	}*/
	
	public function testDelimiterStandaloneWithoutNewLine():Void {
		template = Library.loadTemplate('resources/mu/spec/delimiters/standalone_without_newline.mustache');
		expected = Library.loadTemplate('templates/html/spec/delimiters/standalone_without_newline.txt');
		output = mu.render(template, {  } );
		assertEquals(expected.trim(), output.trim());
	}
	
	/**
	 * Sub section - Whitespace Insensitivity
	 */
	
	public function testDelimiterPairWithPadding():Void {
		template = Library.loadTemplate('resources/mu/spec/delimiters/pair_with_padding.mustache');
		expected = Library.loadTemplate('templates/html/spec/delimiters/pair_with_padding.txt');
		output = mu.render(template, {  } );
		assertEquals(expected.trim(), output.trim());
	}
	
}