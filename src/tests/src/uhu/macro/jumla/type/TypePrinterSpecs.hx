package uhu.macro.jumla.type;

import haxe.Http;
import haxe.unit.TestCase;

#if macro
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.ComplexTypeTools;

using StringTools;
using uhu.macro.Jumla;
#end

/**
 * ...
 * @author Skial Bainn
 */
class TypePrinterSpecs extends TestCase {

	public function new() {
		super();
	}
	
	#if macro
	
	public function testEnum() {
		var expected = '';
		var type:Type = ComplexTypeTools.toType( macro :uhu.macro.jumla.type.TypePrinterSpecs.A<String> );
		var actual = type.printType();
		
		this.assertEquals( expected, actual );
	}
	
	public function testClass() {
		var expected = '';
		var type:Type = ComplexTypeTools.toType( macro :uhu.macro.jumla.type.TypePrinterSpecs.B<String, Int> );
		var actual = type.printType();
		
		this.assertEquals( expected, actual ); 
	}
	
	#end
	
}

@:native('AA') @normal enum A<T1> {
	@:compiler A1;
	@normal A2;
	A3(a:T1);
	A4<T2>(b:T2);
}

@:native('BB') @normal class B<T1, T2> extends Http implements C<T1,T2> {
	public function new() {
		super('');
	}
	
	public static function a1(a:Int, b:String, c:Date): { aa:Int, bb:String, cc:Map < String, Date > } {
		return untyped { };
	}
	
	public static inline function a2<T3>():Void {
		
	}
	
	public static var a3:String = 'Hello';
	
	public var a4(get, never):String;
	
	public function get_a4():String {
		return 'World';
	}
	
	public var a5:Map<String, Date>;
}

@:native('CC') @normal interface C<T1,T2> {
	
}