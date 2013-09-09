package uhx.tem.help;

/**
 * ...
 * @author Skial Bainn
 */

class TemHelp {
	
	@:noCompletion public static function parseSingle<T>(name:String, ele:dtx.DOMNode, attr:Bool, parse:String->dtx.DOMNode->T):T { 
		var v:String = attr ? dtx.single.ElementManipulation.attr( ele, name ) : dtx.single.ElementManipulation.text( ele );
		return parse( v, ele );
	}
	
	@:noCompletion public static function parseCollection<T>(name:String, ele:dtx.DOMNode, attr:Bool, parse:String->dtx.DOMNode->T):Array<T> {  
		var r:Array<T> = [];
		var v:String = '';
		for (child in dtx.single.Traversing.children( ele, true )) {
			v = attr ? dtx.single.ElementManipulation.attr( child, name ) : dtx.single.ElementManipulation.text( child );
			r.push( parse( v, child ) );
		}
		return r;
	}
	
	@:noCompletion public static function setIndividual<T>(value:T, dom:dtx.DOMNode, ?attr:String) { 
		attr == null 
			? dtx.single.ElementManipulation.setText(dom, Std.string( value ))
			: dtx.single.ElementManipulation.setAttr(dom, attr, Std.string( value ));
	}
	
	@:noCompletion public static function setCollection<T>(value:Array<T>, dom:dtx.DOMNode, ?attr:String) {
		for (i in 0...value.length) {
			setCollectionIndividual( value[i], i, dom, attr );
		}
	}
	
	@:noCompletion public static function setCollectionIndividual<T>(value:T, pos:Int, dom:dtx.DOMNode, ?attr:String) { 
		var children = dtx.single.Traversing.children( dom );
		if (children.collection.length > pos) {
			attr != null
				? dtx.single.ElementManipulation.setAttr( children.getNode( pos ), attr, Std.string( value ) )
				: dtx.single.ElementManipulation.setText( children.getNode( pos ), Std.string( value ) );
		} else {
			var c = new dtx.DOMCollection();
			for (i in 0...(pos-(children.collection.length-1))) {
				c.add( dtx.Tools.create( dtx.single.ElementManipulation.tagName( children.getNode() ) ) );
			}
			dtx.single.DOMManipulation.append( dom, null, c );
			children = dtx.single.Traversing.children( dom );
			attr != null 
				? dtx.single.ElementManipulation.setAttr( children.getNode( pos ), attr, Std.string( value ) )
				: dtx.single.ElementManipulation.setText( children.getNode( pos ), Std.string( value ) );
		}
	}
	
	public static var parserMap:Map<String, String->dtx.DOMNode->Dynamic> = [
	'String' => parseString,
	'Int' => parseInt,
	'Float' => parseFloat,
	'Bool' => parseBool,
	
	];
	
	public static function find(type:String):String->dtx.DOMNode->Dynamic {
		return parserMap.get( type );
	}
	
	public static function parseString(value:String, _):String return value;
	public static function parseFloat(value:String, _):Float return Std.parseFloat( value );
	public static function parseInt(value:String, _):Int return Std.parseInt( value );
	public static function parseBool(value:String, _):Bool return value == 'true' ? true : false;
	
}