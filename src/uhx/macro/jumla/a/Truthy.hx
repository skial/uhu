package uhx.macro.jumla.a;

/**
 * ...
 * @author Skial Bainn
 */
abstract Truthy<T>(T) from T to T {
	@:to public function toBool():Bool return this != null;
}