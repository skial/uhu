package ;

import feffects.Tween;

#if js
import uhu.js.RAF;
#end

/**
 * ...
 * @author Skial Bainn
 */

class Veprim extends Tween.TweenObject {
	
	private var __onUpdate:Dynamic;
	private var __onUpdateParams:Array<Dynamic>;
	
	public static function tween(target:Dynamic, properties:Dynamic, duration:Int, ?easing:Easing, autoStart = false, ?onUpdate:Dynamic, onUpdateParams:Array<Dynamic>, ?onFinish:Dynamic, ?onFinishParams:Array<Dynamic>) {
		return new Veprim(target, properties, duration, easing, autoStart, onUpdate, onFinish, onFinishParams);
	}

	public function new(target:Dynamic, properties:Dynamic, duration:Int, ?easing:Easing, autoStart = false, ?onUpdate:Dynamic, onUpdateParams:Array<Dynamic>, onFinish:Dynamic, ?onFinishParams:Array<Dynamic>) {
		super(target, properties, duration, easing, autoStart, onFinish, onFinishParams);
		
		__onUpdate = onUpdate;
		__onUpdateParams = onUpdateParams;
	}
	
	public function onUpdate(method:Dynamic, ?params:Array<Dynamic>):Veprim {
		__onUpdate = method;
		__onUpdateParams = params;
		return this;
	}
	
	override public function start():List<TweenProperty> {
		tweens	= new List<TweenProperty>();
		for ( key in Reflect.fields( properties ) ) {
			var tp = new TweenProperty( target, key, Reflect.field( properties, key ), this.duration, this.easing, false );
			tp.onFinish( this._onFinish, [ tp ] ).start();
			this.tweens.add( tp );
		}
		
		if (__onUpdate != null) {
			this.tweens.last().onUpdate(__onUpdate, __onUpdateParams);
		}
		
		return tweens;
	}
	
}