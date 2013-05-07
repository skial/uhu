package example.jumlaBind;

/**
 * ...
 * @author Skial Bainn
 */
@:build( example.jumlaBind.MyMacro.build() )
class C {
	
	@:bind('example.jumlaBind.A::a') public var c:String;
	
	public function new() {
		
	}
}