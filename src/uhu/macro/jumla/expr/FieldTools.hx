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
		return f.printField();
	}
	
	public static function mkField(n:String):Field {
		return {
			name: n,
			kind: FVar(null, null),
			meta: [],
			pos: Context.currentPos(),
			access: [],
			doc: '',
		}
	}
	
	public static function addAccess(field:Field, a:Access):Field {
		if (field.access.indexOf( a ) == -1) field.access.push( a );
		return field;
	}
	
	public static function removeAccess(field:Field, a:Access):Field {
		if (field.access.indexOf( a ) > -1) field.access.remove( a );
		return field;
	}
	
	public static function mkPublic(f:Field):Field {
		f.addAccess( APublic );
		return f;
	}
	
	public static function rmPublic(f:Field):Field {
		f.removeAccess( APublic );
		return f;
	}
	
	public static function mkPrivate(f:Field):Field {
		f.addAccess( APrivate );
		return f;
	}
	
	public static function rmPrivate(f:Field):Field {
		f.removeAccess( APrivate );
		return f;
	}
	
	public static function mkStatic(f:Field):Field {
		f.addAccess( AStatic );
		return f;
	}
	
	public static function rmStatic(f:Field):Field {
		f.removeAccess( AStatic );
		return f;
	}
	
	public static function mkOverride(f:Field):Field {
		f.addAccess( AOverride );
		return f;
	}
	
	public static function rmOverride(f:Field):Field {
		f.removeAccess( AOverride );
		return f;
	}
	
	private static function mkDynamic(f:Field):Field {
		f.addAccess( ADynamic );
		return f;
	}
	
	private static function rmDynamic(f:Field):Field {
		f.removeAccess( ADynamic );
		return f;
	}
	
	public static function mkInline(f:Field):Field {
		f.addAccess( AInline );
		return f;
	}
	
	public static function rmInline(f:Field):Field {
		f.removeAccess( AInline );
		return f;
	}
	
	public static function mkMacro(f:Field):Field {
		f.addAccess( AMacro );
		return f;
	}
	
	public static function rmMacro(f:Field):Field {
		f.removeAccess( AMacro );
		return f;
	}
	
	public static function toFVar(field:Field, t:ComplexType, e:Expr = null):Field {
		field.kind = FVar(t, e);
		return field;
	}
	
	public static function toFProp(field:Field, g:String = 'default', s:String = 'default', t:ComplexType = null, e:Expr = null):Field {
		field.kind = FProp(g, s, t, e);
		return field;
	}
	
	public static function toFFun(field:Field):Field {
		field.kind = FFun( {
			args: [],
			ret: null,
			expr: null,
			params: []
		} );
		return field;
	}
	
	public static function getMethod(field:Field):Function {
		var result = null;
		switch (field.kind) {
			case FFun(m):
				result = m;
				
			case _:
		}
		return result;
	}
	
	public static function addMeta(f:Field, meta:MetadataEntry):Field {
		if (f.meta == null) f.meta = [];
		f.meta.push( meta );
		return f;
	}
	
	public static function addDoc(f:Field, doc:String):Field {
		f.doc = doc;
		return f;
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
	
	public static inline function mkGetter(v:Field, e:Expr):Field {
		return createGetter( v, e );
	}
	
	@:deprecated public static inline function _getter(variable:Field, expr:Expr):Field {
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
	
	public static inline function mkSetter(v:Field, e:Expr):Field {
		return createSetter( v, e );
	}
	
	@:deprecated public static inline function _setter(variable:Field, expr:Expr):Field {
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
	
	public static function body(field:Field, e:Expr):Field {
		switch (field.kind) {
			case FFun(method):
				method.expr = e;
				
			case _:
		}
		
		return field;
	}
	
	public static function param(field:Field, id:String, ?constraints:Array<ComplexType>):Field {
		switch (field.kind) {
			case FFun(method):
				constraints = constraints == null ? [] : constraints;
				
				method.params.push( {
					name: id,
					constraints: constraints
				} );
				
			case _:
		}
		
		return field;
	}
	
	public static function ret(field:Field, ctype:ComplexType):Field {
		switch (field.kind) {
			case FFun(method):
				method.ret = ctype;
				
			case _:
		}
		
		return field;
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