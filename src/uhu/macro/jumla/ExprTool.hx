package uhu.macro.jumla;

import haxe.macro.Expr;
import uhu.macro.jumla.t.TComplexString;
import uhu.macro.jumla.t.TField;
import uhu.macro.jumla.TypeParamTool;

/**
 * ...
 * @author Skial Bainn
 */

class ExprTool {
	
	@:extern public static inline function toString(e:Expr):String {
		return ComplexString.toString( itsType(e) );
	}

	public static function itsType(e:Expr):TComplexString {
		var result:TComplexString = null;
		
		switch (e.expr) {
			case EConst(c):
				result = ConstantTool.itsType(c);
			case EBlock(_):
				result = { name:'Dynamic', params:[] };
			case EArrayDecl(values):
				result = { name:'Array', params:[] };
				for (v in values) {
					result.params.push( itsType(v) );
				}
			case ENew(type, _):
				result = { name:type.name, params:[] };
				for (p in type.params) {
					result.params.push( TypeParamTool.itsType(p) );
				}
			case EObjectDecl(_):
				result = { name:'Typedef', params:[] };
			case _:
				// TODO handle other types
				trace('ExprTool - UNKNOWN');
				trace(e.expr);
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
			result.push( ExprTool.toTField( field ) );
		}
		
		return result;
	}
	
}