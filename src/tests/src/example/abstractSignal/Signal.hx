package example.abstractSignal;

import thx.core.Procedure;
typedef Sig<T> = thx.react.Signal.Signal1<T>;

/**
 * ...
 * @author Skial Bainn
 */
abstract Signal<T>( { v:T, s:Sig<T> } ) {
	
	public var value(get, set):T;
	
	private function get_value():T {
		return this.v;
	}
	
	private function set_value(v:T):T {
		return this.v = v;
	}
	
	public var signal(get, never):Sig<T>;
	
	private function get_signal():Sig<T> {
		return this.s;
	}

	public inline function new(v: { v:T, s:Sig<T> } ) {
		this = v;
	}
	
	@:to public inline function toT():T {
		return this.v;
	}
	
	@:to public inline function toSignal():Sig<T> {
		return this.s;
	}
	
	@:op(A + B) public static inline function add1(l:Signal<String>, r:String):Signal<String> {
		l.signal.trigger( l.value + r );
		return l;
	}
	
	@:op(A + B) public static inline function add2(l:Signal<String>, r:Signal<String>):Signal<String> {
		var lh:Array<Procedure<String>> = Reflect.field(l.signal, 'handlers');
		var rh:Array<Procedure<String>> = Reflect.field(r.signal, 'handlers');
		var sig = new Sig<String>();
		Reflect.setField(sig, 'handlers', lh.concat( rh ));
		var ns = new Signal<String>( { v: l.value + r.value, s: sig } );
		ns.signal.trigger( l.value + r.value );
		return ns;
	}
	
	@:from public static inline function fromT<T>(value:T) {
		return new Signal( { v: value, s: new Sig<T>() } );
	}
	
}