package uhx.lexer;

import hxparse.Position;

/**
 * ...
 * @author Skial Bainn
 */
class Token<T> {
	
	public var token:T;
	public var position:Position;
	
	public function new(tok:T, pos:Position) {
		token = tok;
		position = pos;
	}
}

enum Keywords {
	EOF;
}