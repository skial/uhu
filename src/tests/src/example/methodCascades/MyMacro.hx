package example.methodCascades;
import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class MyMacro {

	public static function build() {
		var fields = Context.getBuildFields();
		
		for ( field in fields ) {
			
			switch ( field.kind ) {
				
				case FFun( f ):
					f.expr = find( f.expr );
				case _:
					
				
			}
			
		}
		
		return fields;
	}
	
	private static var prev:Var = null;
	
	private static function find(e:Expr):Expr {
		var result = e;
		
		switch ( e.expr ) {
			
			case EBlock( exprs ):
				var new_exprs = [];
				
				for ( expr in exprs ) {
					new_exprs.push( find( expr ) );
				}
				
				result = { expr:EBlock( new_exprs ), pos:e.pos };
				
			case ECall( expr, params ):
				
				result = { expr:ECall( find( expr ), params ), pos:e.pos };
				
			case EField( expr, field ):
				
				result = { expr:EField( find( expr ), field ), pos:e.pos };
				
			case EConst( constant ):
				
				var value = null;
				
				switch ( constant ) {
					
					case CIdent( s ):
						value = s;
						
					case _:
						value = null;
					
				}
				
				if ( value != '_' ) {
					result = { expr:EConst( constant ), pos:e.pos };
				} else {
					result = { expr:EConst( CIdent( prev.name ) ), pos:e.pos };
				}
				
			case EVars( vars ):
				
				prev = vars[0];
				result = { expr:EVars( vars ), pos:e.pos };
				
			case _:
				trace( e );
				
		}
		
		return result;
		
	}
	
}