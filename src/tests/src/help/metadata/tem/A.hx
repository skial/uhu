package help.metadata.tem;

import utest.Assert;

using Detox;

typedef Array2<T> = Array<Array<T>>;

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
	public var node:DOMNode;
	
	public var sarray:Array<String>;
	public var iarray:Array<Int>;
	public var darray:Array<DOMNode>;
	public var nested:Array<Array<DOMNode>>;
	public var deep:Array<Array<Array<Array<Array<Array<String>>>>>>;
	
	var attrSrc:DOMNode;
	var dataName:DOMNode;
	var dataAge:DOMNode;
	var dataHeight:DOMNode;
	var dataSArray:DOMNode;
	var dataIArray:DOMNode;
	var dataDArray:DOMNode;
	var dataNode:DOMNode;
	var dataNested:DOMNode;
	var dataDeep:DOMNode;

	public function new() {
		/*var values:Array<Dynamic> = [src, name, age, height, sarray, iarray, darray, node];
		for (value in values) {
			untyped console.log( value );
		}*/
		
		attrSrc = '[src]'.find().getNode();
		dataName = '[data-name]'.find().getNode();
		dataAge = '[data-age]'.find().getNode();
		dataHeight = '[data-height]'.find().getNode();
		
		dataSArray = '[data-sarray]'.find().getNode();
		dataIArray = '[data-iarray]'.find().getNode();
		dataDArray = '[data-darray]'.find().getNode();
		
		dataNode = '[data-node]'.find().getNode();
		dataNested = '[data-nested]'.find().getNode();
		dataDeep = '[data-deep]'.find().getNode();
		
		Assert.is( src, String );
		Assert.is( name, String );
		Assert.is( age, Int );
		Assert.is( height, Float );
		Assert.is( node, DOMNode );
		
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
		testArray_DOM();
		testDOMNode();
		testNested();
		testDeep();
	}
	
	public function testArray_String() {
		Assert.equals(3, sarray.length);
		Assert.equals('Hello Skial', sarray[0]);
		
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
		Assert.equals(3, iarray.length);
		Assert.equals(11, iarray[0]);
		
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
	
	public function testArray_DOM() {
		Assert.equals(3, darray.length);
		Assert.equals('Hello 1', darray[0].text());
		
		darray = ['<div>World 0</div>'.parse().getNode(), '<div>World 1</div>'.parse().getNode(), '<div>World 2</div>'.parse().getNode()];
		
		Assert.equals(darray[0].text(), dataDArray.children().collection[0].text());
		Assert.equals(darray[1].text(), dataDArray.children().collection[1].text());
		Assert.equals(darray[2].text(), dataDArray.children().collection[2].text());
		
		darray[2] = '<span>Universe 2</span>'.parse().getNode();
		Assert.equals(darray[2].text(), dataDArray.children().collection[2].text());
		
		darray[3] = '<span>Universe 3</span>'.parse().getNode();
		Assert.equals(darray[3].text(), dataDArray.children().collection[3].text());
		
		darray[5] = '<span>Universe 5</span>'.parse().getNode();
		Assert.equals(darray[5].text(), dataDArray.children().collection[5].text());
		
		for (i in 0...darray.length) {
			darray[i].setText( 'Disc World $i' );
		}
		
		Assert.equals('Disc World 5', dataDArray.children().collection[5].text());
		Assert.equals('', dataDArray.children().collection[4].text());
	}
	
	public function testDOMNode() {
		this.node.append( '<span>World!!</span>'.parse().getNode() );
		Assert.equals('Hello 1', this.dataNode.children().collection[0].text());
		Assert.equals('World!!', this.dataNode.children().collection[3].text());
	}
	
	public function testNested() {
		Assert.equals(2, nested.length);
		Assert.equals(3, nested[0].length);
		Assert.equals(3, nested[1].length);
	}
	
	public function testDeep() {
		Assert.equals(3, deep[0][0][0][0][0].length);
		Assert.equals('Hello 1', deep[0][0][0][0][0][0]);
		Assert.equals('Hello 2', deep[0][0][0][0][0][1]);
		Assert.equals('Hello 3', deep[0][0][0][0][0][2]);
	}
	
}