package uhx.ac;

using Lambda;

/**
 * ...
 * @author Skial Bainn
 * Access Control Element
 */
class ACE<TRole,TPrivilege> {
	
	@:noCompletion 
	public var uid:Int;
	
	public var role:TRole;
	public var privileges:Array<TPrivilege>;
	public var parent:ACE<TRole,TPrivilege>;

	public function new() {
		privileges = [];
	}
	
	public function isAllowed(privilege:TPrivilege):Bool {
		var result = privileges.indexOf( privilege ) > -1;
		
		if (!result && parent != null) {
			result = parent.isAllowed( privilege );
		}
		
		return result;
	}
	
}