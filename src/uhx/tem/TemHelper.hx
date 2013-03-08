package uhu.tem;

#if !(macro || neko)
import js.Browser;
import js.html.Event;
import js.html.AnimationEvent;
#end
import uhu.tem.i.ITem;
import haxe.ds.StringMap;
import uhu.tem.t.TemClass;

#if !macro
using Detox;
#end

/**
 * @author Skial Bainn
 */

@:TemIgnore
class TemHelper implements ITem {
	
	public static var classes:StringMap<TemClass>;
	public static var current_index:Int = 0;
	
	public static function __init__() {
		classes = new StringMap<TemClass>();
	}
	
	public function new() {
		
		#if !(macro || neko)
		Browser.window.addEventListener('animationstart', cast onAnimationStart, false);
		#end
		
		// Finally loop through each runtime_classes pair and call TemCreate
		var tem_class = null;
		var node = null;
		
		for (key in classes.keys()) {
			
			tem_class = classes.get( key );
			
			if (tem_class.amount > 0) {
				
				for (value in 0...tem_class.amount) {
					current_index = value;
					Reflect.callMethod( tem_class.cls, Reflect.field( tem_class.cls, 'TemCreate' ), [] );
				}
				
			} else {
				current_index = 0;
				Reflect.callMethod( tem_class.cls, Reflect.field( tem_class.cls, 'TemCreate' ), [] );
			}
			
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