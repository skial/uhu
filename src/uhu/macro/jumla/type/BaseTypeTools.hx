package uhu.macro.jumla.type;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.TypeTools;

/**
 * ...
 * @author Skial Bainn
 */
class BaseTypeTools {

	public static inline function path(base:BaseType):String {
		return base.pack.join( '.' ) + (base.pack.length > 0 ? '.' : '') + base.name;
	}
	
	public static function toTypeParamDecls(base:BaseType):Array<TypeParamDecl> {
		var result:Array<TypeParamDecl> = [];
		
		for (param in base.params) {
			result.push( { name:param.name, constraints:[TypeTools.toComplexType( Context.follow( param.t ) )] } );
		}
		
		return result;
	}
	
}