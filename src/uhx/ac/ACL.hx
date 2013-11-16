package uhx.ac;

import haxe.ds.Option;

/**
 * ...
 * @author Skial Bainn
 * Access Control List
 */
class ACL<TRole, TPrivilege> {
	
	private var roles:Map<Option<TRole>, ACE<TRole, TPrivilege>>;

	public function new() {
		roles = new Map<Option<TRole>, ACE<TRole, TPrivilege>>();
	}
	
	public function addRole(role:TRole, ?parent:TRole):ACE<TRole, TPrivilege> {
		var result:ACE<TRole, TPrivilege>;
		
		if (!roles.exists( Some(role) )) {
			result =  new ACE<TRole, TPrivilege>();
			result.role = role;
			
			if (parent != null) {
				if (roles.exists( Some(parent) )) {
					result.parent = roles.get( Some(parent) );
				} else {
					throw '$parent is not a role. Add it before using it as a parent.';
				}
			}
			
			roles.set( Some(role), result );
			
		} else {
			result = roles.get( Some(role) );
		}
		
		return result;
	}
	
	public function getRole(role:TRole):ACE<TRole, TPrivilege> {
		return roles.get( Some(role) );
	}
	
	public function allow(role:TRole, privileges:Array<TPrivilege>):Bool {
		var result = false;
		
		if (roles.exists( Some(role) )) {
			var r = roles.get( Some(role) );
			r.privileges = r.privileges.concat( privileges );
			result = true;
		}
		
		return result;
	}
	
	public function deny(role:TRole, privileges:Array<TPrivilege>):Bool {
		var result = false;
		
		if (roles.exists( Some(role) )) {
			var r = roles.get( Some(role) );
			for (priv in privileges) {
				r.privileges.remove( priv );
			}
			result = true;
		}
		
		return result;
	}
	
	public function inherit(child:TRole, parent:TRole):Bool {
		var result = false;
		
		if (roles.exists( Some(child) ) && roles.exists( Some(parent) )) {
			roles.get( Some(child) ).parent = roles.get( Some(parent) );
			result = true;
		}
		
		return result;
	}
	
	public function isAllowed(role:TRole, privilege:TPrivilege):Bool {
		var result = false;
		
		if (roles.exists( Some(role) )) {
			result = roles.get( Some(role) ).isAllowed( privilege );
		}
		
		return result;
	}
	
}