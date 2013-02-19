package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.t.TComplexString;
import uhu.macro.jumla.t.TField;
import uhu.macro.jumla.TypeParamTools;

/**
 * ...
 * @author Skial Bainn
 */

class ExprTools {

	public static inline function toString(e:Expr):String {
		return Printer.printExpr( e );
	}
	
	public static function toType(e:Expr):TComplexString {
		var result = null;
		
		switch (e.expr) {
			case EArrayDecl(_) | EArray(_, _):
				result = { name:'Array', params:[] };
				
			case EConst(c):
				result = ConstantTools.toType( c );
				
			case ENew(t, _):
				result = TypePathTools.toType( t );
				
			case EObjectDecl(_):
				result = { name:'Typedef', params:[] };
				
			case _:
				
		}
		
		return result;
	}
	
	public static function toTField(field:Field):TField {
		var result = {
			name:'',
			pos:null,
			access:[],
			kind:null,
		}
		
		result.name = field.name;
		result.pos = field.pos;
		result.access = field.access;
		result.kind = field.kind;
		
		return result;
	}
	
	public static function toTFields(fields:Array<Field>):Array<TField> {
		var result = [];
		
		for (field in fields) {
			result.push( toTField( field ) );
		}
		
		return result;
	}
	
}