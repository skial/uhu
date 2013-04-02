package uhu.macro.jumla.expr;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import uhu.macro.jumla.t.TField;
import uhu.macro.jumla.t.TComplexString;
import uhu.macro.jumla.type.ClassFieldTools;

using Lambda;

/**
 * @author Skial Bainn
 */

class FieldTools {
	
	@:extern public static inline function toString(f:Field):String {
		return Printer.printField( f );
	}
	
	public static function toComplexString(f:Field):TComplexString {
		var result = null;
		
		switch (f.kind) {
			case FVar(t, e) | FProp(_, _, t, e):
				
				if (t != null) {
					
					result = ComplexTypeTools.toComplexString( t );
					
				} else if (e != null) {
					
					result = ExprTools.toComplexString( e );
					
				}
				
			case FFun(m):
				
				result = FunctionTools.toComplexString( m );
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
	
	public static function createGetter(variable:Field, expression:Expr):Field {
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
						expr:expression,
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
	
	public static function createSetter(variable:Field, expression:Expr):Field {
		var result:Field = null;
		
		switch (variable.kind) {
			case FProp( _, s, t, _ ):
				
				result = {
					name:s,
					doc:null,
					access:variable.access,
					kind:FFun( {
						args:[ {
							name:'v',
							opt:false,
							type:t,
						} ],
						ret:t,
						expr:expression,
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
	
	public static function exists(fields:Array<Field>, name:String):Bool {
		var result = fields.exists( function(field):Bool {
			return (field.name == name) ? true : false;
		} );
		
		return result;
	}
	
	public static function get(fields:Array<Field>, name:String):Field {
		var result = null;
		
		for (field in fields) {
			if (field.name == name) {
				result = field;
				break;
			}
		}
		
		return result;
	}
	
	public static inline function isStatic(field:Field, cls:ClassType):Bool {
		return ClassFieldTools.exists( cls.fields.get(), field.name ) ? true : ClassFieldTools.exists( cls.statics.get(), field.name );
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