package uhu.macro.jumla;

import haxe.macro.Context;
import haxe.macro.Expr;
import uhu.macro.jumla.t.TComplexString;

/**
 * @author Skial Bainn
 */

class FieldTools {
	
	@:extern public static inline function toString(f:Field):String {
		return Printer.printField( f );
	}
	
	public static function toType(f:Field):TComplexString {
		var result = null;
		
		switch (f.kind) {
			case FVar(t, e) | FProp(_, _, t, e):
				
				if (t != null) {
					
					result = ComplexTypeTools.toType( t );
					
				} else if (e != null) {
					
					result = ExprTools.toType( e );
					
				}
				
			case FFun(m):
				
				result = FunctionTools.toType( m );
		}
		
		return result;
	}
	
	public static function toFProp(variable:Field):Field {
		
		switch (variable.kind) {
			case FVar( t, e ):
				
				variable.kind = FProp('get_${variable.name}', 'set_${variable.name}', t, e);
				
			case _:
				throw '"${variable.name}" field kind is not of type "FieldType::FVar"';
		}
		
		return variable;
	}
	
	public static function createGetter(variable:Field):Field {
		var result:Field = null;
		
		switch (variable.kind) {
			case FProp( g, _, t, _ ):
				
				result = {
					name:g,
					doc:null,
					access:variable.access,
					kind:FFun( {
						args:[],
						ret:t,
						expr:macro return $i{variable.name},
						params:[]
					} ),
					pos:variable.pos,
					meta:null
				}
				
			case _:
				throw '"${variable.name} field kind is not of type "FieldType::FProp". Use toFProp before calling this method.';
		}
		
		return result;
	}
	
	public static function createSetter(variable:Field):Field {
		var result:Field = null;
		
		switch (variable.kind) {
			case FProp( _, s, t, _ ):
				
				result = {
					name:s,
					doc:null,
					access:variable.access,
					kind:FFun( {
						args:[ {
							name:'val',
							opt:false,
							type:t,
						} ],
						ret:t,
						expr:macro return val,
						params:[]
					} ),
					pos:variable.pos,
					meta:null
				}
				
			case _:
				throw '"${variable.name} field kind is not of type "FieldType::FProp". Use toFProp before calling this method.';
		}
		
		return result;
	}
	
}