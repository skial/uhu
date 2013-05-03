package example.jumlaBind;

import msignal.Signal;
import msignal.Slot;

/**
 * ...
 * @author Skial Bainn
 */
@:build( example.jumlaBind.MyMacro.build() )
class A {
	
	@:bind('example.jumlaBind.B::b') public var a:String;

	public function new() {
		
	}
	
}