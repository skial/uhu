package uhx.tem.help;
import dtx.DOMNode;

using Detox;

/**
 * ...
 * @author Skial Bainn
 */

class TemHelp {
	
	/*public static function parseSingle<T>(name:String, ele:DOMNode, attr:Bool, parse:String->dtx.DOMNode->T):T { 
		var v:String = attr ? ele.attr( name ) : ele.text();
		return parse( v, ele );
	}
	
	public static function parseCollection<T>(name:String, ele:DOMNode, attr:Bool, parse:String->dtx.DOMNode->T):Array<T> {  
		var r:Array<T> = [];
		var v:String = '';
		for (child in dtx.single.Traversing.children( ele, true )) {
			v = attr ? child.attr( name ) : child.text();
			r.push( parse( v, child ) );
		}
		return r;
	}*/
	
	public static function setIndividual<T>(value:T, dom:DOMNode, setter:Dynamic->DOMNode->Void, ?attr:String) { 
		attr == null ? /*dom.setText( Std.string( value ) )*/ setter( value, dom ) : dom.setAttr( attr, Std.string( value ) );
	}
	
	public static function setCollection<T>(values:Iterable<T>, dom:DOMNode, setter:Dynamic->DOMNode->Void, ?attr:String) {
		/*for (i in 0...value.length) {
			setCollectionIndividual( value[i], i, dom, setter, attr );
		}*/
		var pos = 0;
		for (value in values) {
			setCollectionIndividual( value, pos, dom, setter, attr );
			pos++;
		}
	}
	
	public static function setCollectionIndividual<T>(value:T, pos:Int, dom:DOMNode, setter:Dynamic->DOMNode->Void, ?attr:String) { 
		var children = dom.children();
		if (children.collection.length > pos) {
			attr != null 
				? children.getNode( pos ).setAttr( attr, Std.string( value ) )
				//: children.getNode( pos ).setText( Std.string( value ) );
				: setter( value, children.getNode( pos ) );
		} else {
			var c = new dtx.DOMCollection();
			for (i in 0...(pos-(children.collection.length-1))) {
				c.add( children.getNode().tagName().create() );
			}
			dom.append( null, c );
			children = dom.children();
			attr != null 
				? children.getNode( pos ).setAttr( attr, Std.string( value ) )
				//: children.getNode( pos ).setText( Std.string( value ) );
				: setter( value, children.getNode( pos ) );
		}
	}
	
	public static var toMap:Map<String, Dynamic->DOMNode->Void> = [
	'Node' => toNode,
	'toDOMCollection' => toDOMCollection,
	
	];
	
	public static function toNode(value:DOMNode, target:DOMNode) {
		target.replaceWith( value );
	}
	
	public static function toDOMCollection(value:DOMCollection, target:DOMNode) {
		target.replaceWith( null, value );
	}
	
	public static function toDefault(value:Dynamic, target:DOMNode) {
		target.setText( Std.string( value ) );
	}
	
	public static var parserMap:Map<String, String->DOMNode->Bool->Dynamic> = [
	'String' => parseString,
	'Int' => parseInt,
	'Float' => parseFloat,
	'Bool' => parseBool,
	'Xml' => parseXml,
	'Node' => parseNode,
	'DOMCollection' => parseDOMCollection,
	
	];
	
	/*public static function parseString(value:String, _):String return value;
	public static function parseFloat(value:String, _):Float return Std.parseFloat( value );
	public static function parseInt(value:String, _):Int return Std.parseInt( value );
	public static function parseBool(value:String, _):Bool return value == 'true' ? true : false;
	public static function parseXml(value:String, ele:DOMNode):Xml return Xml.parse( ele.html() );
	public static function parseNode(_, target:DOMNode):DOMNode return target;
	public static function parseDOMCollection(value:String, target:DOMNode) {
		trace( value );
		trace( target );
		return target;
	}*/
	
	public static function parseString(name:String, ele:DOMNode, attr:Bool):String return attr?ele.attr(name):ele.text();
	public static function parseFloat(name:String, ele:DOMNode, attr:Bool):Float return Std.parseFloat( attr?ele.attr(name):ele.text() );
	public static function parseInt(name:String, ele:DOMNode, attr:Bool):Int return Std.parseInt( attr?ele.attr(name):ele.text() );
	public static function parseBool(name:String, ele:DOMNode, attr:Bool):Bool return (attr?ele.attr(name):ele.text()) == 'true' ? true : false;
	public static function parseXml(_, ele:DOMNode, _):Xml return Xml.parse( ele.html() );
	public static function parseNode(_g, ele:DOMNode, _):DOMNode return ele;
	public static function parseDOMCollection(_, ele:DOMNode, _):DOMCollection return ele.children();
	
}