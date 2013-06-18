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
class InvertedSpec extends TestCase {
	
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
	 * Inverted Spec
	 * -----
	 * https://github.com/mustache/spec/blob/master/specs/inverted.yml
	 */
	
	public function testFalsey():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/falsey.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/falsey.txt');
		output = mu.render(template, { boolean: false } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testTruthy():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/truthy.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/truthy.txt');
		output = mu.render(template, { boolean: true } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testContext():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/context.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/context.txt');
		output = mu.render(template, { context: { name: 'Joe' } } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testList():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/list.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/list.txt');
		output = mu.render(template, { list: [ { n: 1 }, { n: 2 }, { n: 3 } ] } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testEmptyList():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/empty_list.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/empty_list.txt');
		output = mu.render(template, { list: [  ] } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDoubled():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/doubled.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/doubled.txt');
		output = mu.render(template, { bool: false, two: 'second' } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testNestedFalsey():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/nested_falsey.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/nested_falsey.txt');
		output = mu.render(template, { bool: false } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testNestedTruthy():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/nested_truthy.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/nested_truthy.txt');
		output = mu.render(template, { bool: true } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testContextMisses():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/context_misses.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/context_misses.txt');
		output = mu.render(template, {} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDottedNamesTruthy():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/dotted_names_truthy.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/dotted_names_truthy.txt');
		output = mu.render(template, { a: { b: { c: true } } } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDottedNamesFalsey():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/dotted_names_falsey.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/dotted_names_falsey.txt');
		output = mu.render(template, { a: { b: { c: false } } } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDottedNamesBrokenChains():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/dotted_names_broken_chains.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/dotted_names_broken_chains.txt');
		output = mu.render(template, { a: { b: { c: false } } } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testSurroundingWhitespace():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/surrounding_whitespace.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/surrounding_whitespace.txt');
		output = mu.render(template, { boolean: false } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testInternalWhitespace():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/internal_whitespace.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/internal_whitespace.txt');
		output = mu.render(template, { boolean: false } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testIndentedInlineSection():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/indented_inline_section.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/indented_inline_section.txt');
		output = mu.render(template, { boolean: false } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testStandaloneLines():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/standalone_lines.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/standalone_lines.txt');
		output = mu.render(template, { boolean: false } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testStandaloneIndentedLines():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/standalone_indented_lines.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/standalone_indented_lines.txt');
		output = mu.render(template, { boolean: false } );
		//trace(expected.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		//trace(output.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testStandaloneLinesEndings():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/standalone_lines_endings.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/standalone_lines_endings.txt');
		output = mu.render(template, { boolean: false } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testStandaloneWithoutPreviousLine():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/standalone_without_previous_line.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/standalone_without_previous_line.txt');
		output = mu.render(template, { boolean: false } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testStandaloneWithoutNewLine():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/standalone_without_newline.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/standalone_without_newline.txt');
		output = mu.render(template, { boolean: false } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testPadding():Void {
		template = Library.loadTemplate('resources/mu/spec/inverted/padding.mustache');
		expected = Library.loadTemplate('templates/html/spec/inverted/padding.txt');
		output = mu.render(template, { boolean: false } );
		assertEquals(expected.trim(), output.trim());
	}
	
}