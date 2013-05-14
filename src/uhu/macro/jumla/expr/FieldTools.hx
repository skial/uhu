package uhu.macro.jumla.expr;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import uhu.macro.jumla.type.ClassFieldTools;

using Lambda;
using uhu.macro.Jumla;

/**
 * @author Skial Bainn
 */

class FieldTools {
	
	public static function qualify(f:Field):Field {
		switch( f.kind ) {
			case FVar(t, e):
				f.kind = FVar( t.qualify(), e );
			case FFun(m):
				f.kind = FFun( m.qualify() );
			case FProp(g, s, t, e):
				f.kind = FProp(g, s, t.qualify(), e );
		}
		return f;
	}
	
	@:extern public static inline function toString(f:Field):String {
		return Printer.printField( f );
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
		var type = null;
		
		switch (variable.kind) {
			case FVar(t, _):
				type = t;
				
			case FProp( g, _, t, _ ):
				type = t;
				
			case _:
				throw '"${variable.name} field kind is not of type "FieldType::FProp".';
		}
		
		if (type != null) {
			
			result = {
				name:'get_${variable.name}',
				doc:null,
				access:variable.access,
				kind:FFun( {
					args:[],
					ret:type,
					expr:expression,
					params:[]
				} ),
				pos:variable.pos,
				meta:null
			}
			
		}
		
		return result;
	}
	
	@:extern public static inline function _getter(variable:Field, expr:Expr):Field {
		return createGetter( variable, expr );
	}
	
	public static function createSetter(variable:Field, expression:Expr):Field {
		var result:Field = null;
		var type = null;
		
		switch (variable.kind) {
			case FVar(t, _):
				type = t;
				
			case FProp( _, _, t, _ ):
				type = t;
				
			case _:
				throw '"${variable.name} field kind is not of type "FieldType::FProp".';
		}
		
		if (type != null) {
			
			result = {
				name:'set_${variable.name}',
				doc:null,
				access:variable.access,
				kind:FFun( {
					args:[ {
						name:'v',
						opt:false,
						type:type,
					} ],
					ret:type,
					expr:expression,
					params:[]
				} ),
				pos:variable.pos,
				meta:null
			};
			
		}
		
		return result;
	}
	
	@:extern public static inline function _setter(variable:Field, expr:Expr):Field {
		return createSetter( variable, expr );
	}
	
	public static inline function isStatic(field:Field, ?cls:ClassType):Bool {
		//return ClassFieldTools.exists( cls.fields.get(), field.name ) ? true : ClassFieldTools.exists( cls.statics.get(), field.name );
		return field.access.has( AStatic );
	}
	
	public static inline function isInline(field:Field):Bool {
		return field.access.has( AInline );
	}
	
}