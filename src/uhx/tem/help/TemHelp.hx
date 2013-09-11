package uhx.tem.help;
import dtx.DOMNode;

using Detox;

/**
 * ...
 * @author Skial Bainn
 */

class TemHelp {
	
	public static function parseSingle<T>(name:String, ele:DOMNode, attr:Bool, parse:String->dtx.DOMNode->T):T { 
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
	}
	
	public static function setIndividual<T>(value:T, dom:DOMNode, setter:Dynamic->DOMNode->Void, ?attr:String) { 
		attr == null ? /*dom.setText( Std.string( value ) )*/ setter( value, dom ) : dom.setAttr( attr, Std.string( value ) );
	}
	
	public static function setCollection<T>(value:Array<T>, dom:DOMNode, setter:Dynamic->DOMNode->Void, ?attr:String) {
		for (i in 0...value.length) {
			setCollectionIndividual( value[i], i, dom, setter, attr );
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
	];
	
	public static function toNode(value:DOMNode, target:DOMNode) {
		target.replaceWith( value );
	}
	
	public static function toDefault(value:Dynamic, target:DOMNode) {
		target.setText( Std.string( value ) );
	}
	
	public static var parserMap:Map<String, String->DOMNode->Dynamic> = [
	'String' => parseString,
	'Int' => parseInt,
	'Float' => parseFloat,
	'Bool' => parseBool,
	'Xml' => parseXml,
	'Node' => parseNode,
	];
	
	public static function find(type:String):String->DOMNode->Dynamic {
		return parserMap.get( type );
	}
	
	public static function parseString(value:String, _):String return value;
	public static function parseFloat(value:String, _):Float return Std.parseFloat( value );
	public static function parseInt(value:String, _):Int return Std.parseInt( value );
	public static function parseBool(value:String, _):Bool return value == 'true' ? true : false;
	public static function parseXml(value:String, ele:DOMNode):Xml return Xml.parse( ele.html() );
	
	public static function parseNode(value:String, target:DOMNode) {
		trace( value );
		trace( target );
		return value;
	}
	
}