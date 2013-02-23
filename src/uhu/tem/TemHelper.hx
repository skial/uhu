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
		var node = null;
		
		for (key in runtime_classes.keys()) {
			cls = runtime_classes.get( key );
			#if !macro
			//searchNode( '.UhuTem[class~="$key"]' );
			node = '.UhuTem[class~="$key"]'.find().collection[0];
			#end
			Reflect.callMethod( cls, Reflect.field( cls, 'TemCreate' ), [node] );
		}
		
	}
	
	#if !macro
	private function onAnimationStart(e:AnimationEvent) {
		if (e.animationName == 'nodeInserted') {
			
			/**
			 * parse the new dom for any UhuTem classes
			 */
			
		}
	}
	#end
	
}