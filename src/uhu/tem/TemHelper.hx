package uhu.tem;

#if !macro
import js.Browser;
import js.html.Event;
import js.html.AnimationEvent;
#end
import uhu.tem.i.ITem;
import uhu.tem.Common;
import haxe.ds.StringMap;

#if !macro
using Detox;
#end

/**
 * @author Skial Bainn
 */

@:TemIgnore
class TemHelper implements ITem {
	
	public static var runtime_classes:StringMap<Class<Dynamic>>;
	
	public static function __init__() {
		runtime_classes = new StringMap();
	}
	
	public function new() {
		
		#if !macro
		Browser.window.addEventListener('animationstart', cast onAnimationStart, false);
		#end
		
		// Finally loop through each runtime_classes pair and call TemCreate
		var cls = null;
		
		for (key in runtime_classes.keys()) {
			cls = runtime_classes.get( key );
			#if !macro
			searchNode( '.UhuTem[class~="$key"]' );
			#end
			Reflect.callMethod( cls, Reflect.field( cls, 'TemCreate' ), [] );
		}
		
	}
	
	#if !macro
	private function searchNode(selector:String) {
		var collection = selector.find().collection;
		
		for (node in collection) {
			
			if ( hasInstanceBindings( node ) ) {
				bindInstanceFields( node );
			}
			
			if ( hasStaticBindings( node ) ) {
				bindStaticFields( node );
			}
			
		}
	}
	
	private function hasInstanceBindings(node:DOMNode):Bool {
		var result = false;
		
		if (node.attr( Common.x_instance ) != '') {
			result = true;
		}
		
		return result;
	}
	
	private function hasStaticBindings(node:DOMNode):Bool {
		var result = false;
		
		if (node.attr( Common.x_static ) != '') {
			result = true;
		}
		
		return result;
	}
	
	private function bindInstanceFields(node:DOMNode) {
		var attribute = node.attr( Common.x_instance );
		var fields = attribute.split(' ');
		var name = '';
		
		for (field in fields) {
			
			name = field.split('.');
			
		}
	}
	
	private function bindStaticFields(node:DOMNode) {
		
	}
	
	private function onAnimationStart(e:AnimationEvent) {
		if (e.animationName == 'nodeInserted') {
			
			/**
			 * parse the new dom for any UhuTem classes
			 */
			
		}
	}
	#end
	
}