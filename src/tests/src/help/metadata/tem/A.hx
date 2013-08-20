package help.metadata.tem;

import utest.Assert;

using Detox;

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
		
		var attrSrc:DOMNode = '[src]'.find().getNode();
		var dataList:DOMNode = '[data-list]'.find().getNode();
		var dataName:DOMNode = '[data-name]'.find().getNode();
		var dataAge:DOMNode = '[data-age]'.find().getNode();
		var dataHeight:DOMNode = '[data-height]'.find().getNode();
		
		Assert.is( src, String );
		Assert.is( name, String );
		Assert.is( age, Int );
		Assert.is( height, Float );
		
		Assert.equals( 'http://lorempixel.com/50/50', src );
		Assert.equals( 'http://lorempixel.com/50/50', attrSrc.attr('src') );
		
		Assert.equals( 'Skial Bainn', name );
		Assert.equals( 'Skial Bainn', dataName.text() );
		
		Assert.equals( 25, age );
		Assert.equals( '25', dataAge.text() );
		
		Assert.equals( 5.9, height );
		Assert.equals( '5.9', dataHeight.text() );
		
		list = ['1', '2', '3'];
		
		Assert.equals('1', dataList.children().collection[0].text());
		Assert.equals('2', dataList.children().collection[1].text());
		Assert.equals('3', dataList.children().collection[2].text());
		
		list[2] = 'Goodbye Bob!';
		Assert.equals('Goodbye Bob!', dataList.children().collection[2].text());
		
		list[3] = 'Newy Newness';
		Assert.equals('Newy Newness', dataList.children().collection[3].text());
		
		list[5] = 'Future';
		Assert.equals('Future', dataList.children().collection[5].text());
		
		untyped console.log( list );
	}
	
}