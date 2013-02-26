package uhu.tem;

#if !(macro || neko)
import js.Browser;
import js.html.Event;
import js.html.AnimationEvent;
#end
import uhu.tem.i.ITem;
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
	public static var runtime_count:StringMap<Int>;
	public static var runtime_index:Int = 0;
	
	public static function __init__() {
		runtime_classes = new StringMap<Class<Dynamic>>();
		runtime_count = new StringMap<Int>();
	}
	
	public function new() {
		
		#if !(macro || neko)
		Browser.window.addEventListener('animationstart', cast onAnimationStart, false);
		#end
		
		// Finally loop through each runtime_classes pair and call TemCreate
		var cls = null;
		var node = null;
		
		for (key in runtime_classes.keys()) {
			cls = runtime_classes.get( key );
			#if !(macro || neko)
			//node = '.UhuTem[class~="$key"]'.find().collection[0];
			#end
			//Reflect.callMethod( cls, Reflect.field( cls, 'TemCreate' ), [node] );
			if (!runtime_count.exists( key )) {
				runtime_index = 0;
				runtime_count.set( key, runtime_index );
			} else {
				runtime_index = runtime_count.get( key );
				runtime_index++;
				runtime_count.set( key, runtime_index );
			}
			Reflect.callMethod( cls, Reflect.field( cls, 'TemCreate' ), [] );
		}
		
	}
	
	#if !(macro || neko)
	private function onAnimationStart(e:AnimationEvent) {
		if (e.animationName == 'nodeInserted') {
			
			/**
			 * parse the new dom for any UhuTem classes
			 */
			
		}
	}
	#end
	
}