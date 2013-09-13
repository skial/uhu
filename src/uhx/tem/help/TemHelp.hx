package uhx.tem.help;
import dtx.DOMNode;

using Detox;

/**
 * ...
 * @author Skial Bainn
 */

class TemHelp {
	
	public static function setIndividual<T>(value:T, dom:DOMNode, setter:Dynamic->DOMNode->Void, ?attr:String) { 
		attr == null ? /*dom.setText( Std.string( value ) )*/ setter( value, dom ) : dom.setAttr( attr, Std.string( value ) );
	}
	
	public static function setCollection<T>(values:Iterable<T>, dom:DOMNode, setter:Dynamic->DOMNode->Void, ?attr:String) {
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
	
	public static var parserMap:Map<String, String->DOMNode->Bool->Array<String>->Dynamic> = [
	'String' => parseString,
	'Int' => parseInt,
	'Float' => parseFloat,
	'Bool' => parseBool,
	'Xml' => parseXml,
	'Node' => parseNode,
	'DOMCollection' => parseDOMCollection,
	'Array' => parseArray,
	
	];
	
	public static function parseArray(name:String, ele:DOMNode, attr:Bool, types:Array<String>):Array<Dynamic> {
		var result:Array<Dynamic> = [];
		var type = types.shift();
		
		for (child in ele.children()) {
			
			result.push( TemHelp.parserMap.get( type )( name, child, attr, types.copy() ) );
			
		}
		
		return result;
	}
	
	public static function parseString(name:String, ele:DOMNode, attr:Bool, _):String return attr?ele.attr(name):ele.text();
	public static function parseFloat(name:String, ele:DOMNode, attr:Bool, _):Float return Std.parseFloat( attr?ele.attr(name):ele.text() );
	public static function parseInt(name:String, ele:DOMNode, attr:Bool, _):Int return Std.parseInt( attr?ele.attr(name):ele.text() );
	public static function parseBool(name:String, ele:DOMNode, attr:Bool, _):Bool return (attr?ele.attr(name):ele.text()) == 'true' ? true : false;
	public static function parseXml(_, ele:DOMNode, _, _):Xml return Xml.parse( ele.html() );
	public static function parseNode(_g, ele:DOMNode, _, _):DOMNode return ele;
	public static function parseDOMCollection(_, ele:DOMNode, _, _):DOMCollection return ele.children();
	
}