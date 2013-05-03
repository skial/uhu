package example.exprCache;
import haxe.ds.StringMap;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class Macro {
	
	public static var cache:StringMap<Field> = new StringMap<Field>();

	public static function build() {
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		
		for (field in fields) {
			if (!cache.exists( cls.name + '::' + field.name )) {
				cache.set( cls.name + '::' + field.name, field );
			}
		}
		
		trace( cls.name );
		
		for (key in cache.keys()) {
			var cfield = cache.get( key );
			trace( cfield.name );
			switch (cfield.kind) {
				case FFun(method):
					method.expr = method.expr.concat( macro $v { key } );
					
				case _:
			}
		}
		
		return fields;
	}
	
}