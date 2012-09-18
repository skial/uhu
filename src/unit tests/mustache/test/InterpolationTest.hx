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
class InterpolationTest {
	
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
	 * Interpolation Tests
	 * -----
	 * https://github.com/mustache/spec/blob/master/specs/interpolation.yml
	 */
	
	@Test
	public function testNoInterpolation():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/no_interpolation.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/no_interpolation.txt');
		output = mu.render(template, {} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testBasicInterpolation():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/basic_interpolation.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/basic_interpolation.txt');
		output = mu.render(template, { subject: "world" } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testHTMLEscaping():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/html_escaping.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/html_escaping.txt');
		output = mu.render(template, { forbidden: '& " < >' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testTripleMustache():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/triple_mustache.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/triple_mustache.txt');
		output = mu.render(template, { forbidden: '& " < >' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testAmpersand():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/ampersand.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/ampersand.txt');
		output = mu.render(template, { forbidden: '& " < >' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testBasicIntegerInterpolation():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/basic_integer_interpolation.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/basic_integer_interpolation.txt');
		output = mu.render(template, { mph: 85 } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testTripleIntegerInterpolation():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/triple_integer_interpolation.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/triple_integer_interpolation.txt');
		output = mu.render(template, { mph: 85 } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testAmpersandIntegerInterpolation():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/ampersand_integer_interpolation.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/ampersand_integer_interpolation.txt');
		output = mu.render(template, { mph: 85 } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testBasicDecimalInterpolation():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/basic_decimal_interpolation.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/basic_decimal_interpolation.txt');
		output = mu.render(template, { power: 1.210 } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testTripleDecimalInterpolation():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/triple_decimal_interpolation.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/triple_decimal_interpolation.txt');
		output = mu.render(template, { power: 1.210 } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testAmpersandDecimalInterpolation():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/ampersand_decimal_interpolation.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/ampersand_decimal_interpolation.txt');
		output = mu.render(template, { power: 1.210 } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testBasicContextMiss():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/basic_context_miss.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/basic_context_miss.txt');
		output = mu.render(template, {  } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testTripleContextMiss():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/triple_context_miss.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/triple_context_miss.txt');
		output = mu.render(template, {  } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testAmpersandContextMiss():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/ampersand_context_miss.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/ampersand_context_miss.txt');
		output = mu.render(template, {  } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testDottedNames():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/dotted_names.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/dotted_names.txt');
		output = mu.render(template, { person: { name: 'Joe' } } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testTripleDottedNames():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/triple_dotted_names.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/triple_dotted_names.txt');
		output = mu.render(template, { person: { name: 'Joe' } } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testAmpersandDottedNames():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/ampersand_dotted_names.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/ampersand_dotted_names.txt');
		output = mu.render(template, { person: { name: 'Joe' } } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testDottedNamesArbitraryDepth():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/dotted_names_arbitrary_depth.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/dotted_names_arbitrary_depth.txt');
		output = mu.render(template, { a: { b: { c: { d: { e: { name: 'Phil' } } } } } } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testDottedNamesBrokenChains():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/dotted_names_broken_chains.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/dotted_names_broken_chains.txt');
		output = mu.render(template, { a: { } } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testDottedNamesBrokenChainResolution():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/dotted_names_broken_chain_resolution.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/dotted_names_broken_chain_resolution.txt');
		output = mu.render(template, { 
			a: { b: { } },
			c: { name: 'Jim' } 
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testInitialResolution():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/initial_resolution.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/initial_resolution.txt');
		output = mu.render(template, { 
			a: { b: { c: { d: { e: { name: 'Phil' } } } } },
			b: { c: { d: { e: { name: 'Wrong' } } } }
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testContextPrecedence():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/context_precedence.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/context_precedence.txt');
		output = mu.render(template, { 
			a: { b: { } },
			b: { c: 'ERROR' }
		} );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testSurroundingWhitespace():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/surrounding_whitespace.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/surrounding_whitespace.txt');
		output = mu.render(template, { string: '---' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testTripleSurroundingWhitespace():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/triple_surrounding_whitespace.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/triple_surrounding_whitespace.txt');
		output = mu.render(template, { string: '---' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testAmpersandSurroundingWhitespace():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/ampersand_surrounding_whitespace.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/ampersand_surrounding_whitespace.txt');
		output = mu.render(template, { string: '---' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testStandalone():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/standalone.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/standalone.txt');
		output = mu.render(template, { string: '---' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testTripleStandalone():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/triple_standalone.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/triple_standalone.txt');
		output = mu.render(template, { string: '---' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testAmpersandStandalone():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/ampersand_standalone.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/ampersand_standalone.txt');
		output = mu.render(template, { string: '---' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testPadding():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/padding.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/padding.txt');
		output = mu.render(template, { string: '---' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testTriplePadding():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/triple_padding.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/triple_padding.txt');
		output = mu.render(template, { string: '---' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
	@Test
	public function testAmpersandPadding():Void {
		template = Library.loadTemplate('unit tests/mustache/resources/mu/spec/interpolation/ampersand_padding.mustache');
		expected = Library.loadTemplate('unit tests/mustache/templates/html/spec/interpolation/ampersand_padding.txt');
		output = mu.render(template, { string: '---' } );
		Assert.areEqual(expected.trim(), output.trim());
	}
	
}