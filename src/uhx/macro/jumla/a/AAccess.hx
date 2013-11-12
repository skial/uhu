package uhx.macro.jumla.a;

import haxe.macro.Expr;

using Lambda;

/**
 * ...
 * @author Skial Bainn
 */
abstract AAccess(Array<Access>) from Array<Access> to Array<Access> {

	public var isPublic(get, set):Bool;
	public var isStatic(get, set):Bool;
	
	// ++ internal
	
	private function get_isPublic():Bool return this.indexOf( APublic ) > -1;
	private function get_isStatic():Bool return this.indexOf( AStatic ) > -1;
	
	private function set_isPublic(v:Bool):Bool {
		if (v) {
			while (this.indexOf( APrivate ) > -1) this.remove( APrivate );
			this.push( APublic );
		} else {
			while (this.indexOf( APublic ) > -1) this.remove( APublic );
			this.push( APrivate );
		}
		return v;
	}
	
	private function set_isStatic(v:Bool):Bool {
		// We only want one AStatic.
		while (this.indexOf( AStatic ) > -1) this.remove( AStatic );
		if (v) this.push( AStatic );
		return v;
	}
	
	// -- internal
	
}