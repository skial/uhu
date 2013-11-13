package uhx.macro.jumla.a;

/**
 * ...
 * @author Skial Bainn
 */
abstract FilterBy<T>(T) from T {
	public var by(get, never):T;
	private function get_by():T return this;
}