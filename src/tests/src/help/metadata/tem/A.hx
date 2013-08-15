package help.metadata.tem;

import Detox;
import utest.Assert;

/**
 * ...
 * @author Skial Bainn
 */
@:tem
class A implements Klas {
	
	public var src:String = '';
	public var name:String = '';
	public var age:Int = 0;
	public var height:Float = .0;
	
	public var list:Array<String>;

	public function new() {
		var values:Array<Dynamic> = [src, name, age, height, list];
		for (value in values) {
			untyped console.log( value );
		}
		
		Assert.is( src, String );
		Assert.is( name, String );
		Assert.is( age, Int );
		Assert.is( height, Float );
		
		Assert.equals( 'http://lorempixel.com/50/50', src );
		Assert.equals( 'Skial Bainn', name );
		Assert.equals( 25, age );
		Assert.equals( 5.9, height );
		
		list[2] = 'Goodbye Bob!';
	}
	
}