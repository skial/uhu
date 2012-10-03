package ;

import feffects.Tween;
#if js
	#if raf
	import uhu.js.RAF;
	#end
import uhu.Library;
#end

/**
 * ...
 * @author Skial Bainn
 */

// Veprim is Albanian for move
class Veprim extends Tween {

	static function AddTween(tween : Tween) {
		if ( !Tween._isTweening )
		{
			#if ( !nme && js )
				#if raf
				Library.window.requestAnimationFrame(cb_tick);
				#else
				Tween._timer 		= new haxe.Timer( Tween.INTERVAL ) ;
				Tween._timer.run 	= cb_tick;
				#end
			#else
				Lib.current.stage.addEventListener( Event.ENTER_FRAME, cb_tick );
			#end
			Tween._isTweening	= true;
			cb_tick();
		}
		
		Tween._aTweens.add( tween );
	}
	
	static function cb_tick( #if ( raf || nme || flash ) ?_ #end ) : Void	{
		for ( i in Tween._aTweens ) {
			i.doInterval();
		}
		
		#if raf
		Library.window.requestAnimationFrame(cb_tick);
		#end
	}
	
	public function new( init : Float, end : Float, dur : Int, ?easing : Easing, ?updateF : Float->Void, ?endF : Void->Void, autoStart = false ) {
		super(init, end, dur, easing, updateF, endF, autoStart);
	}
	
	override public function start():Void {
		_startTime = getStamp();
		_reverseTime = getStamp();
		
		if ( duration == 0 )
			finish();
		else
			AddTween( this );
		isPlaying = true;
	}
	
}

class VeprimObject extends TweenObject {
	
	public static function tween( target : Dynamic, properties : Dynamic, duration : Int, ?easing : Easing, ?onFinish : Void->Void, autoStart = false ) {
		return new VeprimObject(target, properties, duration, easing, onFinish, autoStart);
	}
	
	public function new(target : Dynamic, properties : Dynamic, duration : Int, ?easing : Easing, ?onFinish : Void->Void, autoStart = false) {
		super(target, properties, duration, easing, onFinish, autoStart);
	}
	
}

private class VeprimProperty extends Veprim {
	
	var _target		: Dynamic;
	var _property	: String;
	var __endF		: VeprimProperty->Void;
	
	public function new( target : Dynamic, prop : Dynamic, duration : Int, ?easing : Easing, endF : VeprimProperty->Void ) {
		_target = target;
		_property = Reflect.fields( prop )[ 0 ];
		__endF = endF;
		
		var init = Reflect.getProperty( target, _property );
		var end = Reflect.getProperty( prop, _property );
		
		super( init, end, duration, easing );
		
		onUpdate( _updateF );
		onFinish( _endF );
	}
	
	inline function _updateF( n : Float ) {
		Reflect.setProperty( _target, _property, n );
	}
	
	inline function _endF() {
		__endF( this );
	}
	
}