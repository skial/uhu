package uhx.macro;

import sys.FileSystem;
import taurine.io.Path;
import uhu.macro.Du;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using StringTools;
using sys.FileSystem;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class Protocol {
	
	public static function handler():Type {
		var mod = Context.getLocalModule();
		var pos = Context.currentPos();
		var path = Path.normalize( Context.getPosInfos( pos ).file );
		var parts = path.split( Path.sep );
		var file = parts.pop().replace( '.hx', '' );
		
		parts.push( 'impl' );
		
		if (!parts.join( Path.sep ).fullPath().exists()) {
			Context.error( parts.join( Path.sep ) + ' does not exist.', pos );
		}
		
		parts.push( file + '_' + Du.target );
		
		if (!(parts.join( Path.sep ) + '.hx').fullPath().exists()) {
			parts.pop();
			parts.push( file );
			
			if (!(parts.join( Path.sep ) + '.hx').fullPath().exists()) {
				Context.error( parts.join( Path.sep ) + ' does not exist.', pos );
			}
			
		}
		
		// TODO is this needed any more?
		while (true) {
			if (!~/[\w\d\s]+/.match( parts[0] )) {
				parts.shift();
			} else {
				break;
			}
		}
		
		// TODO is this needed any more?
		for (bad in ['src', 'source']) {
			if (parts[0].trim() == bad) {
				parts.shift();
				break;
			}
		}
		
		for (part in parts.copy()) if (!mod.startsWith( part )) parts.shift() else break;
		
		return Context.follow( Context.getType( parts.join('.') ) );
	}
	
}