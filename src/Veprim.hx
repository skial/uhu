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

// Veprim is Albanian for move, I hope...
class Veprim extends Tween {
	
	#if raf
	static var _rafId:Int;
	#end

	static function AddTween(tween : Tween) {
		if ( !Tween._isTweening )
		{
			#if ( !nme && js )
				#if raf
				_rafId = Library.window.requestAnimationFrame(cb_tick);
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
	
	static function RemoveTween( tween : Tween ) : Void {
		if ( !Tween._isTweening )
			return;
		Tween._aTweens.remove( tween );
		if (Tween._aTweens.isEmpty() && Tween._aPaused.isEmpty() )	{
			#if ( !nme && js )
				#if raf
				if (_rafId != null) {
					Library.window.cancelAnimationFrame(_rafId);
					_rafId = null;
				}
				#else
				_timer.stop() ;
				_timer	= null ;
				#end
			#else
				Lib.current.stage.removeEventListener( Event.ENTER_FRAME, cb_tick );
			#end
			Tween._isTweening = false;
		}
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
			Veprim.AddTween( this );
		isPlaying = true;
	}
	
	override public function stop():Void {
		Veprim.RemoveTween( this );
		isPlaying = false;
	}
	
	override private function finish():Void {
		Veprim.RemoveTween( this );
		var val = 0.0;
		isPlaying = false;
		if ( reversed )
			val = _initVal;
		else
			val = _endVal;
		
		updateF( val );
		endF();
	}
	
}

class VeprimObject extends TweenObject {
	
	public static function tween( target : Dynamic, properties : Dynamic, duration : Int, ?easing : Easing, ?onFinish : Void->Void, autoStart = false ) {
		return new VeprimObject(target, properties, duration, easing, onFinish, autoStart);
	}
	
	public function new(target : Dynamic, properties : Dynamic, duration : Int, ?easing : Easing, ?onFinish : Void->Void, autoStart = false) {
		this.target		= target;
		this.properties	= properties;
		this.duration	= duration;
		
		if ( easing != null )
			this.easing = easing;
		if( onFinish != null )
			endF = onFinish;
		
		tweens		= new FastList<Tween>();
		for ( key in Reflect.fields( properties ) ) {
			var prop = { };
			Reflect.setProperty( prop, key, Reflect.getProperty( properties, key ) );
			var tweenProp = new VeprimProperty(target, prop, duration, easing, _endF);
			tweens.add( tweenProp );
		}
		
		if ( autoStart )
			start();
	}
	
	/*override function _endF(tp:VeprimProperty) {
		tweens.remove( tp );
		if ( tweens.isEmpty() )			
			endF();
	}*/
	
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