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
	
	public var sarray:Array<String>;
	public var iarray:Array<Int>;
	public var xarray:Array<Xml>;
	
	var attrSrc:DOMNode;
	var dataName:DOMNode;
	var dataAge:DOMNode;
	var dataHeight:DOMNode;
	
	var dataSArray:DOMNode;
	var dataIArray:DOMNode;
	var dataXArray:DOMNode;

	public function new() {
		var values:Array<Dynamic> = [src, name, age, height, sarray, iarray, xarray];
		for (value in values) {
			untyped console.log( value );
		}
		
		attrSrc = '[src]'.find().getNode();
		dataName = '[data-name]'.find().getNode();
		dataAge = '[data-age]'.find().getNode();
		dataHeight = '[data-height]'.find().getNode();
		
		dataSArray = '[data-sarray]'.find().getNode();
		dataIArray = '[data-iarray]'.find().getNode();
		dataXArray = '[data-xarray]'.find().getNode();
		
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
		
		testArray_String();
		testArray_Int();
		testArray_Xml();
	}
	
	public function testArray_String() {
		sarray = ['1', '2', '3'];
		
		Assert.equals('1', dataSArray.children().collection[0].text());
		Assert.equals('2', dataSArray.children().collection[1].text());
		Assert.equals('3', dataSArray.children().collection[2].text());
		
		sarray[2] = 'Goodbye Bob!';
		Assert.equals('Goodbye Bob!', dataSArray.children().collection[2].text());
		
		sarray[3] = 'Newy Newness';
		Assert.equals('Newy Newness', dataSArray.children().collection[3].text());
		
		sarray[5] = 'Future';
		Assert.equals('Future', dataSArray.children().collection[5].text());
		
		for (i in 0...sarray.length) {
			sarray[i] += ' loop';
		}
		
		Assert.equals('Future loop', sarray[5]);
		Assert.equals('Future loop', dataSArray.children().collection[5].text());
		
		Assert.equals('undefined loop', sarray[4]);
		Assert.equals('undefined loop', dataSArray.children().collection[4].text());
	}
	
	public function testArray_Int() {
		iarray = [66, -100, 23];
		
		Assert.equals(66, dataIArray.children().collection[0].text());
		Assert.equals(-100, dataIArray.children().collection[1].text());
		Assert.equals(23, dataIArray.children().collection[2].text());
		
		iarray[2] = 44;
		Assert.equals(44, dataIArray.children().collection[2].text());
		
		iarray[3] = 200;
		Assert.equals(200, dataIArray.children().collection[3].text());
		
		iarray[5] = 99999;
		Assert.equals(99999, dataIArray.children().collection[5].text());
		
		for (i in 0...iarray.length) {
			iarray[i] += 1;
		}
		
		Assert.equals( -99, iarray[1]);
		Assert.equals( -99, dataIArray.children().collection[1].text());
		
		Assert.equals('' + Math.NaN, '' + iarray[4]);
		Assert.equals('' + Math.NaN, dataIArray.children().collection[4].text());
	}
	
	public function testArray_Xml() {
		xarray = [Xml.parse('World 0'), Xml.parse('World 1'), Xml.parse('World 2')];
	}
}