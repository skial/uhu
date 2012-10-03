package ;

import feffects.Tween;
import haxe.FastList;
#if js
	#if raf
	import uhu.js.RAF;
	#end
import uhu.js.Console;
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
		
		#if (js && raf)
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

class VeprimObject {
	
	public var tweens		(default, null)			: FastList<Veprim>;
	public var target		(default, null)			: Dynamic;
	public var properties	(default, null)			: Dynamic;
	public var duration		(default, null)			: Int;
	public var easing		(default, null)			: Easing;
	public var isPlaing		(get_isPlaying, null)	: Bool;
	function get_isPlaying() {
		for ( tween in tweens ) 
			if ( tween.isPlaying )
				return true;
		return false;
	}
	
	public static function tween( target : Dynamic, properties : Dynamic, duration : Int, ?easing : Easing, ?onFinish : Void->Void, autoStart = false ) {
		return new VeprimObject( target, properties, duration, easing, onFinish, autoStart );
	}
	
	public function new( target : Dynamic, properties : Dynamic, duration : Int, ?easing : Easing, ?onFinish : Void->Void, autoStart = false ) {
		this.target		= target;
		this.properties	= properties;
		this.duration	= duration;
		
		if ( easing != null )
			this.easing = easing;
		if( onFinish != null )
			endF = onFinish;
		
		tweens		= new FastList<Veprim>();
		for ( key in Reflect.fields( properties ) ) {
			
			var prop = { };
			Reflect.setProperty( prop, key, Reflect.getProperty( properties, key ) );
			var tweenProp = new VeprimProperty( target, prop, duration, easing, _endF );
			tweens.add( tweenProp );
		}
		
		if ( autoStart )
			start();
	}
	
	public function setEasing( easing : Easing ) {
		for ( tweenProp in tweens )
			tweenProp.setEasing( easing );
		return this;
	}
	
	public function start() {
		for ( tweenProp in tweens )
			tweenProp.start();
		return tweens;
	}
	
	public function pause() {
		for ( tweenProp in tweens )
			tweenProp.pause();
	}
	
	public function resume() {
		for ( tweenProp in tweens )
			tweenProp.resume();
	}
	
	public function seek( n : Int ) {
		for ( tweenProp in tweens )
			tweenProp.seek( n );
	}
	
	public function reverse() {
		for ( tweenProp in tweens )
			tweenProp.reverse();
	}
	
	public function stop() {
		for ( tweenProp in tweens )
			tweenProp.stop();
	}
	
	public function onFinish( f : Void->Void ) {
		endF = f;
		return this;
	}
		
	dynamic function endF() {}
		
	function _endF( tp : VeprimProperty ) {
		tweens.remove( tp );
		if ( tweens.isEmpty() )			
			endF();
	}
	
}

private class VeprimProperty extends Veprim {
	
	var _target		: Dynamic;
	var _property	: String;
	var __endF		: VeprimProperty->Void;
	
	#if js
	private static var cssMap = { top:'px', left:'px', bottom:'px', right:'px', width:'px', height:'px', opacity:'' };
	var _isCss		: Bool;
	var _cssValue	: String;
	#end
	
	public function new( target : Dynamic, prop : Dynamic, duration : Int, ?easing : Easing, endF : VeprimProperty->Void ) {
		_target = target;
		_property = Reflect.fields( prop )[ 0 ];
		__endF = endF;
		
		#if js
		_isCss = Reflect.hasField(cssMap, _property);
		_cssValue = _isCss ? Reflect.field(cssMap, _property) : '';
		var init = (!_isCss ? Reflect.getProperty( target, _property ) : Std.parseFloat(Reflect.getProperty(untyped target.style, _property ) ));
		#else
		var init = Reflect.getProperty( target, _property );
		#end
		var end = Reflect.getProperty( prop, _property );
		
		super( init, end, duration, easing );
		
		onUpdate( _updateF );
		onFinish( _endF );
	}
	
	inline function _updateF( n : Float ) {
		#if js
		if (!_isCss) {
			Reflect.setProperty( _target, _property, n );
		} else {
			Reflect.setProperty(untyped _target.style, _property, n + _cssValue);
		}
		#else
		Reflect.setProperty( _target, _property, n );
		#end
	}
	
	inline function _endF() {
		__endF( this );
	}
	
}