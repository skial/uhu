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
	
	@:extern public static inline function toString(e:Expr):String {
		return ComplexString.toString( toType(e) );
	}

	public static function toType(e:Expr):TComplexString {
		var result:TComplexString = null;
		
		switch (e.expr) {
			case EConst(c):
				result = ConstantTools.toType(c);
			case EBlock(_):
				result = { name:'Dynamic', params:[] };
			case EArrayDecl(values):
				result = { name:'Array', params:[] };
				for (v in values) {
					result.params.push( toType(v) );
				}
			case ENew(type, _):
				result = { name:type.name, params:[] };
				for (p in type.params) {
					result.params.push( TypeParamTools.toType(p) );
				}
			case EObjectDecl(_):
				result = { name:'Typedef', params:[] };
			case _:
				// TODO handle other types
				trace('ExprTool - UNKNOWN');
				trace('ExprTool - Not Implemented');
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
			result.push( toTField( field ) );
		}
		
		return result;
	}
	
}