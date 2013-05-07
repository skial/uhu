package example.jumlaBind;

/**
 * ...
 * @author Skial Bainn
 */
@:build( example.jumlaBind.MyMacro.build() )
class A {
	
	@:bind('example.jumlaBind.B::b') public var a:String;
	@:bind('example.jumlaBind.B::b') public var aa:String;

	public function new() {
		
	}
	
}