package uhu.js;

/**
 * @author Skial Bainn
 */

@:arrayAccess
abstract JSArray(Array<T>)<T> {
	
	#if !display
	@:to public inline function toStdArray():Array<T> {
		return this;
	}
	#end
	
	public inline function length():Int {
		return this.length;
	}
	
	public inline function new():Void {
		this = new Array<T>();
	}
	
	public inline function concat(a:JSArray<T>):JSArray<T> untyped {
		return this.concat(a);
	}
	
	public inline function join(sep:String):String {
		return this.join(sep);
	}
	
	public inline function pop():Null<T> {
		return this.pop();
	}
	
	public inline function push(x:T):Int {
		return this.push(x);
	}
	
	public inline function reverse():Void {
		this.reverse();
	}
	
	public inline function shift():Null<T> {
		return this.shift();
	}
	
	public inline function slice(pos:Int, ?end:Int):JSArray<T> untyped {
		return this.slice(pos, end);
	}
	
	public inline function sort(f:T->T->Int):Void {
		this.sort(f);
	}
	
	public inline function splice(pos:Int, len:Int):JSArray<T> untyped {
		return this.splice(pos, len);
	}
	
	@:to public inline function toString():String {
		return '[' + this.toString() + ']';
	}
	
	public inline function unshift(x:T):Bool untyped {
		return this.unshift(x);
	}
	
	public inline function insert(pos:Int, x:T):Void {
		this.insert(pos, x);
	}
	
	public inline function remove(x:T):Bool untyped {
		return this.remove(x);
	}
	
	public inline function copy():JSArray<T> untyped {
		return this.copy();
	}
	
	public inline function iterator():Iterator<T> {
		return this.iterator();
	}
	
	public inline function map<S>(f:T->S):JSArray<S> untyped {
		return this.map(f);
	}
	
	public inline function filter(f:T->Bool):JSArray<T> untyped {
		return this.filter(f);
	}
	
}