package uhx.core;

/**
 * ...
 * @author Skial Bainn
 */
abstract Truthy<T>(T) from T to T {
	@:to public function toBool():Bool return this != null;
	@:op(!A) public static function not<T>(v:Truthy<T>):Bool return !v.toBool();
}