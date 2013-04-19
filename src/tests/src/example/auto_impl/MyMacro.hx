package example.auto_impl;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;

using StringTools;

/**
 * ...
 * @author Skial Bainn
 */
class MyMacro {

	public static function build():Type {
		var path = Context.getPosInfos( Context.currentPos() ).file.split('/');
		var file = path.pop().replace('.hx', '');
		
		if (path[0].trim() == 'src' || path[0].trim() == 'source' ) path.shift();
		
		trace(file);
		trace(path.join('/'));
		
		path.push('impl');
		path.push(file + '_js');
		
		return Context.follow( Context.getType( path.join('.') ) );
	}
	
}