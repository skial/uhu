package uhx.tem.help;

using Detox;

/**
 * ...
 * @author Skial Bainn
 */
class TemIterator<T> {
	
	@:isVar private var parent(get, null):DOMCollection;
	
	private function get_parent():DOMCollection {
		return parent;
	}
	
	public function new(parent:DOMCollection) {
		this.parent = parent;
	}
	
	public function getIndividual(pos:Int) {
		var diff = pos > parent.length ? parent.length - pos : 0;
		
		if (diff > 0) {
			var tag = parent.first().tagName;
			
			for (i in 0...diff) {
				
				parent.append( '<$tag></$tag>'.parse().getNode() );
				
			}
		}
		
		return parent.children( true ).collection[ pos ];
	}
	
	public function setAttr(pos:Int, name:String, value:T) {
		getIndividual( pos ).setAttr( name, '$value' );
	}
	
	public function setEle(pos:Int, value:T) {
		getIndividual( pos ).setText( '$value' );
	}
	
}