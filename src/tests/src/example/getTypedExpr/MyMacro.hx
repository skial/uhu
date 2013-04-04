package example.getTypedExpr;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class MyMacro {

	public static function build():Array<Field> {
		var foo = Context.getType( 'Foo' );
		
		switch (foo) {
			case TInst(t, _):
				var cls = t.get();
				
				for (field in cls.statics.get()) {
					trace( Context.getTypedExpr( field.expr() ) );
				}
				
			case _:
				
		}
		
		return Context.getBuildFields();
	}
	
}