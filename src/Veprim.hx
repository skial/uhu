package ;

import feffects.Tween;
import uhu.js.RAF;
import uhu.Library;

/**
 * ...
 * @author Skial Bainn
 */

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
			UTween.AddTween( this );
		isPlaying = true;
	}
	
}