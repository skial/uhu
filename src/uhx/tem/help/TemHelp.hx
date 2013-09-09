package uhx.tem.help;
import dtx.DOMNode;

using Detox;

/**
 * ...
 * @author Skial Bainn
 */

class TemHelp {
	
	public static function parseSingle<T>(name:String, ele:DOMNode, attr:Bool, parse:String->dtx.DOMNode->T):T { 
		//var v:String = attr ? dtx.single.ElementManipulation.attr( ele, name ) : dtx.single.ElementManipulation.text( ele );
		var v:String = attr ? ele.attr( name ) : ele.text();
		return parse( v, ele );
	}
	
	public static function parseCollection<T>(name:String, ele:DOMNode, attr:Bool, parse:String->dtx.DOMNode->T):Array<T> {  
		var r:Array<T> = [];
		var v:String = '';
		for (child in dtx.single.Traversing.children( ele, true )) {
			//v = attr ? dtx.single.ElementManipulation.attr( child, name ) : dtx.single.ElementManipulation.text( child );
			v = attr ? child.attr( name ) : child.text();
			r.push( parse( v, child ) );
		}
		return r;
	}
	
	public static function setIndividual<T>(value:T, dom:DOMNode, ?attr:String) { 
		/*attr == null 
			? dtx.single.ElementManipulation.setText(dom, Std.string( value ))
			: dtx.single.ElementManipulation.setAttr(dom, attr, Std.string( value ));*/
		attr == null ? dom.setText( Std.string( value ) ) : dom.setAttr( attr, Std.string( value ) );
	}
	
	public static function setCollection<T>(value:Array<T>, dom:DOMNode, ?attr:String) {
		for (i in 0...value.length) {
			setCollectionIndividual( value[i], i, dom, attr );
		}
	}
	
	public static function setCollectionIndividual<T>(value:T, pos:Int, dom:DOMNode, ?attr:String) { 
		//var children = dtx.single.Traversing.children( dom );
		var children = dom.children();
		if (children.collection.length > pos) {
			/*attr != null
				? dtx.single.ElementManipulation.setAttr( children.getNode( pos ), attr, Std.string( value ) )
				: dtx.single.ElementManipulation.setText( children.getNode( pos ), Std.string( value ) );*/
			attr != null 
				? children.getNode( pos ).setAttr( attr, Std.string( value ) )
				: children.getNode( pos ).setText( Std.string( value ) );
		} else {
			var c = new dtx.DOMCollection();
			for (i in 0...(pos-(children.collection.length-1))) {
				//c.add( dtx.Tools.create( dtx.single.ElementManipulation.tagName( children.getNode() ) ) );
				c.add( children.getNode().tagName().create() );
			}
			//dtx.single.DOMManipulation.append( dom, null, c );
			dom.append( null, c );
			//children = dtx.single.Traversing.children( dom );
			children = dom.children();
			/*attr != null
				? dtx.single.ElementManipulation.setAttr( children.getNode( pos ), attr, Std.string( value ) )
				: dtx.single.ElementManipulation.setText( children.getNode( pos ), Std.string( value ) );*/
			attr != null 
				? children.getNode( pos ).setAttr( attr, Std.string( value ) )
				: children.getNode( pos ).setText( Std.string( value ) );
		}
	}
	
	public static var parserMap:Map<String, String->DOMNode->Dynamic> = [
	'String' => parseString,
	'Int' => parseInt,
	'Float' => parseFloat,
	'Bool' => parseBool,
	'Node' => parseNode,
	];
	
	public static function find(type:String):String->DOMNode->Dynamic {
		return parserMap.get( type );
	}
	
	public static function parseString(value:String, _):String return value;
	public static function parseFloat(value:String, _):Float return Std.parseFloat( value );
	public static function parseInt(value:String, _):Int return Std.parseInt( value );
	public static function parseBool(value:String, _):Bool return value == 'true' ? true : false;
	public static function parseNode(value:String, node:DOMNode) return { };
	
}