package uhu.mu;

import haxe.unit.TestCase;
//import uhu.mu.Renderer;
//import uhu.mu.Settings;
//import uhu.mu.Common;
import uhu.Library;
import Mustache;

import utest.Assert;

using StringTools;

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
		template = Library.loadTemplate('resources/mu/spec/comments/inline.mustache');
		expected = Library.loadTemplate('templates/html/spec/comments/inline.txt');
		output = mu.render(template, new Map<String,Dynamic>() );
		Assert.equals(expected, output);
	}
	
	public function testMultiline():Void {
		template = Library.loadTemplate('resources/mu/spec/comments/multiline.mustache');
		expected = Library.loadTemplate('templates/html/spec/comments/multiline.txt');
		output = mu.render(template, new Map<String,Dynamic>() );
		Assert.equals(expected, output);
	}
	
	public function testStandalone():Void {
		template = Library.loadTemplate('resources/mu/spec/comments/standalone.mustache');
		expected = Library.loadTemplate('templates/html/spec/comments/standalone.txt');
		output = mu.render(template, new Map<String,Dynamic>() );
		Assert.equals(expected, output);
	}
	
	public function testIndentedStandalone():Void {
		template = Library.loadTemplate('resources/mu/spec/comments/indented_standalone.mustache');
		expected = Library.loadTemplate('templates/html/spec/comments/indented_standalone.txt');
		output = mu.render(template, new Map<String,Dynamic>() );
		Assert.equals(expected, output);
	}
	
	public function testStandaloneLineEnding():Void {
		template = Library.loadTemplate('resources/mu/spec/comments/standalone_line_ending.mustache');
		expected = Library.loadTemplate('templates/html/spec/comments/standalone_line_ending.txt');
		output = mu.render(template, new Map<String,Dynamic>() );
		Assert.equals(expected, output);
	}
	
	public function testStandaloneWithoutPreviousLine():Void {
		template = Library.loadTemplate('resources/mu/spec/comments/standalone_without_previous_line.mustache');
		expected = Library.loadTemplate('templates/html/spec/comments/standalone_without_previous_line.txt');
		output = mu.render(template, new Map<String,Dynamic>() );
		Assert.equals(expected, output);
	}
	
	public function testStandaloneWithoutNewLine():Void {
		template = Library.loadTemplate('resources/mu/spec/comments/standalone_without_newline.mustache');
		expected = Library.loadTemplate('templates/html/spec/comments/standalone_without_newline.txt');
		output = mu.render(template, new Map<String,Dynamic>() );
		Assert.equals(expected, output);
	}
	
	public function testMultilineStandalone():Void {
		template = Library.loadTemplate('resources/mu/spec/comments/multiline_standalone.mustache');
		expected = Library.loadTemplate('templates/html/spec/comments/multiline_standalone.txt');
		output = mu.render(template, new Map<String,Dynamic>() );
		Assert.equals(expected, output);
	}
	
	public function testIndentedMultilineStandalone():Void {
		template = Library.loadTemplate('resources/mu/spec/comments/indented_multiline_standalone.mustache');
		expected = Library.loadTemplate('templates/html/spec/comments/indented_multiline_standalone.txt');
		output = mu.render(template, new Map<String,Dynamic>() );
		Assert.equals(expected, output);
	}
	
	public function testIndentedInline():Void {
		template = Library.loadTemplate('resources/mu/spec/comments/indented_inline.mustache');
		expected = Library.loadTemplate('templates/html/spec/comments/indented_inline.txt');
		output = mu.render(template, new Map<String,Dynamic>() );
		Assert.equals(expected, output);
	}
	
	public function testSorroundingWhitespace():Void {
		template = Library.loadTemplate('resources/mu/spec/comments/surrounding_whitespace.mustache');
		expected = Library.loadTemplate('templates/html/spec/comments/surrounding_whitespace.txt');
		output = mu.render(template, new Map<String,Dynamic>() );
		Assert.equals(expected, output);
	}
	
}