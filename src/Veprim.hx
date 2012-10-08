package ;

import feffects.Tween;

/**
 * ...
 * @author Skial Bainn
 */

class Veprim extends Tween.TweenObject {
	
	private var __onUpdate:Dynamic;
	
	public static function tween(target:Dynamic, properties:Dynamic, duration:Int, ?easing:Easing, autoStart = false, ?onUpdate:Dynamic, ?onFinish:Dynamic, ?onFinishParams:Array<Dynamic>) {
		return new Veprim(target, properties, duration, easing, autoStart, onUpdate, onFinish, onFinishParams);
	}

	public function new(target:Dynamic, properties:Dynamic, duration:Int, ?easing:Easing, autoStart = false, ?onUpdate:Dynamic, onFinish:Dynamic, ?onFinishParams:Array<Dynamic>) {
		super(target, properties, duration, easing, autoStart, onFinish, onFinishParams);
		
		__onUpdate = onUpdate;
	}
	
	public function onUpdate(method:Dynamic):Veprim {
		__onUpdate = method;
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
			this.tweens.last().onUpdate(__onUpdate);
		}
		
		return tweens;
	}
	
}