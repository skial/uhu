package uhu.macro.jumla;

import haxe.ds.StringMap;
import Map;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.unit.TestCase;
import uhx.http.impl.t.TRequest;

import haxe.macro.Type;

using uhu.macro.Jumla;
using haxe.macro.ComplexTypeTools;

/**
 * ...
 * @author Skial Bainn
 */

class TypeToolsSpecs extends TestCase {
	
	public var expr:ComplexType;
	public var type:Type;

	public function new() {
		super();
	}
	
	public function testIfEnum() {
		expr = macro : uhx.http.Method;
		type = expr.toType();
		assertTrue( type.isEnum() );
	}
	
	public function testIfTypedef() {
		expr = macro : TRequest;
		type = expr.toType();
		assertTrue( type.isTypedef() );
	}
	
	public function testIfAbstract() {
		expr = macro : Map<String, String>;
		type = expr.toType();
		assertTrue( type.isAbstract() );
	}
	
	public function testIfClass() {
		expr = macro : StringTools;
		type = expr.toType();
		assertTrue( type.isClass() );
	}
	
	public function testIfFunction() {
		expr = macro : String->String->Int->Int->Void;
		type = expr.toType();
		assertTrue( type.isFunction() );
	}
	
	public function testIfStructure() {
		expr = macro : { name:String, age:Int };
		type = expr.toType();
		assertTrue( type.isStructure() );
	}
	
	public function testIfStructure_alt() {
		expr = macro : TRequest;
		type = expr.toType();
		assertTrue( type.isStructure() );
	}
	
	public function testIfDynamic() {
		expr = macro : Dynamic;
		type = expr.toType();
		assertTrue( type.isDynamic() );
	}
	
}