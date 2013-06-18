package uhu.macro.jumla;

import Map;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.ds.StringMap;
import haxe.macro.Context;
import haxe.unit.TestCase;
import uhx.http.impl.e.EMethod;
import uhx.http.impl.t.TRequest;
import haxe.macro.ComplexTypeTools;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
 
class TypeToolsSpecs extends TestCase {
	
	public var type:Type;
	public var expr:ComplexType;

	public function new() {
		super();
	}
	
	public function testIfEnum() {
		expr = macro : uhx.http.impl.e.EMethod;
		type = ComplexTypeTools.toType( expr );
		assertTrue( type.isEnum() );
	}
	
	public function testIfTypedef() {
		expr = macro : TRequest;
		type = ComplexTypeTools.toType( expr );
		assertTrue( type.isTypedef() );
	}
	
	public function testIfAbstract() {
		expr = macro : Map<String, String>;
		type = ComplexTypeTools.toType( expr );
		assertTrue( type.isAbstract() );
	}
	
	public function testIfClass() {
		expr = macro : uhu.macro.jumla.TypeToolsSpecs;
		type = ComplexTypeTools.toType( expr );
		assertTrue( type.isClass() );
	}
	
	public function testIfFunction() {
		expr = macro : String->String->Int->Int->Void;
		type = ComplexTypeTools.toType( expr );
		assertTrue( type.isMethod() );
	}
	
	public function testIfStructure() {
		expr = macro : { name:String, age:Int };
		type = ComplexTypeTools.toType( expr );
		assertTrue( type.isStructure() );
	}
	
	public function testIfStructure_alt() {
		expr = macro : TRequest;
		type = ComplexTypeTools.toType( expr );
		assertTrue( type.isStructure() );
	}
	
	public function testIfDynamic() {
		expr = macro : Dynamic;
		type = ComplexTypeTools.toType( expr );
		assertTrue( type.isDynamic() );
	}
	
}