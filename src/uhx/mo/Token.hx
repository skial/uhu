package uhx.mo;

import hxparse.Position;
import uhx.mo.TokenDef;

/**
 * ...
 * @author Skial Bainn
 */
class Token<Kwd> {
	
	public var token:TokenDef<Kwd>;
	//public var position:Position;
	
	public function new(tok:TokenDef<Kwd>, pos:Position) {
		token = tok;
		//position = pos;
	}
}