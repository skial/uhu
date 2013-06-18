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
class InterpolationSpec extends TestCase {
	
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
	 * Interpolation Tests
	 * -----
	 * https://github.com/mustache/spec/blob/master/specs/interpolation.yml
	 */
	
	public function testNoInterpolation():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/no_interpolation.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/no_interpolation.txt');
		output = mu.render(template, {} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testBasicInterpolation():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/basic_interpolation.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/basic_interpolation.txt');
		output = mu.render(template, { subject: "world" } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testHTMLEscaping():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/html_escaping.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/html_escaping.txt');
		output = mu.render(template, { forbidden: '& " < >' } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testTripleMustache():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/triple_mustache.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/triple_mustache.txt');
		output = mu.render(template, { forbidden: '& " < >' } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testAmpersand():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/ampersand.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/ampersand.txt');
		output = mu.render(template, { forbidden: '& " < >' } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testBasicIntegerInterpolation():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/basic_integer_interpolation.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/basic_integer_interpolation.txt');
		output = mu.render(template, { mph: 85 } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testTripleIntegerInterpolation():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/triple_integer_interpolation.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/triple_integer_interpolation.txt');
		output = mu.render(template, { mph: 85 } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testAmpersandIntegerInterpolation():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/ampersand_integer_interpolation.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/ampersand_integer_interpolation.txt');
		output = mu.render(template, { mph: 85 } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testBasicDecimalInterpolation():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/basic_decimal_interpolation.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/basic_decimal_interpolation.txt');
		output = mu.render(template, { power: 1.210 } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testTripleDecimalInterpolation():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/triple_decimal_interpolation.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/triple_decimal_interpolation.txt');
		output = mu.render(template, { power: 1.210 } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testAmpersandDecimalInterpolation():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/ampersand_decimal_interpolation.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/ampersand_decimal_interpolation.txt');
		output = mu.render(template, { power: 1.210 } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testBasicContextMiss():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/basic_context_miss.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/basic_context_miss.txt');
		output = mu.render(template, {  } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testTripleContextMiss():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/triple_context_miss.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/triple_context_miss.txt');
		output = mu.render(template, {  } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testAmpersandContextMiss():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/ampersand_context_miss.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/ampersand_context_miss.txt');
		output = mu.render(template, {  } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDottedNames():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/dotted_names.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/dotted_names.txt');
		output = mu.render(template, { person: { name: 'Joe' } } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testTripleDottedNames():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/triple_dotted_names.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/triple_dotted_names.txt');
		output = mu.render(template, { person: { name: 'Joe' } } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testAmpersandDottedNames():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/ampersand_dotted_names.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/ampersand_dotted_names.txt');
		output = mu.render(template, { person: { name: 'Joe' } } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDottedNamesArbitraryDepth():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/dotted_names_arbitrary_depth.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/dotted_names_arbitrary_depth.txt');
		output = mu.render(template, { a: { b: { c: { d: { e: { name: 'Phil' } } } } } } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDottedNamesBrokenChains():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/dotted_names_broken_chains.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/dotted_names_broken_chains.txt');
		output = mu.render(template, { a: { } } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testDottedNamesBrokenChainResolution():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/dotted_names_broken_chain_resolution.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/dotted_names_broken_chain_resolution.txt');
		output = mu.render(template, { 
			a: { b: { } },
			c: { name: 'Jim' } 
		} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testInitialResolution():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/initial_resolution.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/initial_resolution.txt');
		output = mu.render(template, { 
			a: { b: { c: { d: { e: { name: 'Phil' } } } } },
			b: { c: { d: { e: { name: 'Wrong' } } } }
		} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testContextPrecedence():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/context_precedence.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/context_precedence.txt');
		output = mu.render(template, { 
			a: { b: { } },
			b: { c: 'ERROR' }
		} );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testSurroundingWhitespace():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/surrounding_whitespace.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/surrounding_whitespace.txt');
		output = mu.render(template, { string: '---' } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testTripleSurroundingWhitespace():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/triple_surrounding_whitespace.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/triple_surrounding_whitespace.txt');
		output = mu.render(template, { string: '---' } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testAmpersandSurroundingWhitespace():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/ampersand_surrounding_whitespace.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/ampersand_surrounding_whitespace.txt');
		output = mu.render(template, { string: '---' } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testStandalone():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/standalone.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/standalone.txt');
		output = mu.render(template, { string: '---' } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testTripleStandalone():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/triple_standalone.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/triple_standalone.txt');
		output = mu.render(template, { string: '---' } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testAmpersandStandalone():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/ampersand_standalone.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/ampersand_standalone.txt');
		output = mu.render(template, { string: '---' } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testPadding():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/padding.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/padding.txt');
		output = mu.render(template, { string: '---' } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testTriplePadding():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/triple_padding.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/triple_padding.txt');
		output = mu.render(template, { string: '---' } );
		assertEquals(expected.trim(), output.trim());
	}
	
	public function testAmpersandPadding():Void {
		template = Library.loadTemplate('resources/mu/spec/interpolation/ampersand_padding.mustache');
		expected = Library.loadTemplate('templates/html/spec/interpolation/ampersand_padding.txt');
		output = mu.render(template, { string: '---' } );
		assertEquals(expected.trim(), output.trim());
	}
	
}