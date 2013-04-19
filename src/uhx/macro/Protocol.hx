package uhx.macro;

import sys.FileSystem;
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
		var pos = Context.currentPos();
		var path = Context.getPosInfos( pos ).file;
		var parts = path.split('/');
		var file = parts.pop().replace( '.hx', '' );
		
		parts.push( 'impl' );
		
		if (!parts.join('/').fullPath().exists()) {
			Context.error( parts.join('/') + ' does not exist.', pos );
		}
		
		parts.push( file + '_' + Du.target );
		
		if (!(parts.join('/') + '.hx').fullPath().exists()) {
			parts.pop();
			parts.push( file );
			
			if (!(parts.join('/') + '.hx').fullPath().exists()) {
				Context.error( parts.join('/') + ' does not exist.', pos );
			}
			
		}
		
		for (bad in ['src', 'source']) {
			if (parts[0].trim() == bad) {
				parts.shift();
				break;
			}
		}
		
		return Context.follow( Context.getType( parts.join('.') ) );
	}
	
}