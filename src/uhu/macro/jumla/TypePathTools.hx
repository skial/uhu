package uhu.macro.jumla;

import haxe.macro.Context;
import haxe.macro.Expr;
import uhu.macro.jumla.t.TComplexString;

using uhu.macro.Jumla;

/**
 * @author Skial Bainn
 */

class TypePathTools {
	
	public static function qualify(t:TypePath):TypePath {
		var result = t;
		var type = Context.getType( path( t ) );
		type = Context.follow( type );
		var ctype = Context.toComplexType( type );
		
		if (ctype != null) {
			switch ( ctype ) {
				case TPath( p ): result = p;
				case TExtend( p, _ ): result = p;
				case _:
			}
		}
		
		return result;
	}
	
	public static inline function path(t:TypePath):String {
		return t.pack.join('.') + (t.pack.length > 0 ? '.' : '') + t.name;
	}
	
	public static inline function clean(t:TypePath):TypePath {
		return qualify( t );
	}
	
	@:extern public static inline function toString(t:TypePath):String {
		return Printer.printTypePath( t );
	}
	
	public static function toComplexString(t:TypePath):TComplexString {
		var result = { name:t.pack.join( '.' ) + (t.pack.length > 0 ? '.' : '') + t.name, params:[] };
		
		for (i in t.params) {
			result.params.push( TypeParamTools.toComplexString( i ) );
		}
		
		return result;
	}
	
}