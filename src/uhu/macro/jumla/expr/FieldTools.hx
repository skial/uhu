package uhu.macro.jumla.expr;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import uhu.macro.jumla.Common;

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
	
	public static function isMethod(field:Field):Bool {
		var result = false;
		
		switch (field.kind) {
			case FFun(_):
				result = true;
			case _:
		}
		
		return result;
	}
	
	public static function arity(field:Field):Int {
		var result = 0;
		
		switch(field.kind) {
			case FFun(method):
				result = method.args.length;
				
			case _:
		}
		
		return result;
	}
	
	public static function args(field:Field):Array<FunctionArg> {
		var result = [];
		
		switch (field.kind) {
			case FFun(method):
				result = method.args;
				
			case _:
		}
		
		return result;
	}
	
	public static function isVariable(field:Field):Bool {
		var result = false;
		
		switch (field.kind) {
			case FVar(_, _):
				result = true;
			case _:
		}
		
		return result;
	}
	
	public static function isProperty(field:Field):Bool {
		var result = false;
		
		switch (field.kind) {
			case FProp(_, _, _, _):
				result = true;
			case _:
		}
		
		return result;
	}
	
	public static inline function isPublic(field:Field):Bool {
		return field.access.has( APublic );
	}
	
	public static inline function isPrivate(field:Field):Bool {
		return field.access.has( APrivate );
	}
	
	public static inline function isOverride(field:Field):Bool {
		return field.access.has( AOverride );
	}
	
	public static inline function isDynamic(field:Field):Bool {
		return field.access.has( ADynamic );
	}
	
	public static inline function isMacro(field:Field):Bool {
		return field.access.has( AMacro );
	}
	
	public static inline function isStatic(field:Field, ?cls:ClassType):Bool {
		//return ClassFieldTools.exists( cls.fields.get(), field.name ) ? true : ClassFieldTools.exists( cls.statics.get(), field.name );
		return field.access.has( AStatic );
	}
	
	public static inline function isInline(field:Field):Bool {
		return field.access.has( AInline );
	}
	
	public static function typeof(field:Field):Type {
		var result = null;
		
		switch (field.kind) {
			case FVar(t, _):
				result = t.toType();
				
			case FProp(_, _, t, _):
				result = t.toType();
				
			case FFun(method):
				result = TFun( [for (a in method.args) { name: a.name, opt: a.opt, t: a.type.toType() }], method.ret.toType() );
				
		}
		
		return result;
	}
	
	// auto-completion helpers
	
	public static inline function remove(fields:Array<Field>, key:String):Bool {
		return Common.remove(fields, key);
	}
	
	public static inline function get(fields:Array<Field>, key:String):Field {
		return Common.get(fields, key);
	}
	
	public static inline function exists(fields:Array<Field>, key:String):Bool {
		return Common.exists(fields, key);
	}
	
	public static inline function getAll(fields:Array<Field>, key:String):Array<Field> {
		return Common.getAll(fields, key);
	}
	
}