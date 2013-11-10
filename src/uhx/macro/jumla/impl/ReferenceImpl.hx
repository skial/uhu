package uhx.macro.jumla.impl;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using Lambda;
using uhx.macro.Jumla;
using haxe.macro.ComplexTypeTools;

/**
 * ...
 * @author Skial Bainn
 */
class ReferenceImpl<T> {
	
	public var name(get, set):String;
	public var meta(get, set):MetaImpl;
	
	public var isStatic(get, set):Bool;
	public var isPublic(get, set):Bool;
	public var isDynamic(get, set):Bool;
	public var isMacro(get, set):Bool;
	public var isInline(get, set):Bool;
	
	public var isProperty(get, never):Bool;
	public var isVar(get, never):Bool;
	public var isMethod(get, never):Bool;
	
	public var typeof(get, never):Type;
	
	public function new(field:T) {
		this.field = field;
	}
	
	// ++ internal
	
	@:noCompletion public var field:T;
	private var fkind(get, never):Int;
	private var efield(get, set):Field;
	private var cfield(get, set):ClassField;
	
	private function get_fkind():Int return field.fieldType();
	private function get_efield():Field return untyped field;
	private function get_cfield():ClassField return untyped field;
	
	private function set_efield(v:Field):Field return untyped field = v;
	private function set_cfield(v:ClassField):ClassField return untyped field = v;
	
	private function get_name():String {
		return switch (fkind) {
			case 0: efield.name;
			case 1: cfield.name;
			case _: null;
		};
	}
	private function set_name(v:String):String {
		return switch (fkind) {
			case 0: efield.name = v;
			case 1: v;
			case _: null;
		};
	}
	
	private function get_meta():MetaImpl {
		return switch (fkind) {
			case 0: efield.meta;
			case 1: cfield.meta.get();
			case _: null;
		};
	}
	
	private function set_meta(v:Metadata):MetaImpl {
		return switch(fkind) {
			case 0: efield.meta = v;
			case 1: 
				for (m in cfield.meta.get()) cfield.meta.remove( m.name );
				for (m in v) cfield.meta.add( m.name, m.params, m.pos );
				v;
			case _: null;
		};
	}
	
	private function get_isStatic():Bool {
		return switch (fkind) {
			case 0: efield.access.indexOf( AStatic ) > -1;
			case 1: false;
			case _: null;
		}
	}
	
	private function set_isStatic(v:Bool):Bool {
		switch (fkind) {
			case 0: v ? efield.access.push( AStatic ) : while (isStatic) efield.access.remove( AStatic );
			case 1: v;
			case _: null;
		}
		return v;
	}
	
	private function get_isPublic():Bool {
		return switch(fkind) {
			case 0: efield.access.indexOf( APublic ) > -1;
			case 1: cfield.isPublic;
			case _: null;
		}
	}
	
	private function set_isPublic(v:Bool):Bool {
		switch (fkind) {
			case 0: v ? efield.access.push( APublic ) : while (isPublic) efield.access.remove( APublic );
			case 1: v;
			case _: null;
		}
		return v;
	}
	
	private function get_isDynamic():Bool {
		return switch(fkind) {
			case 0: efield.access.indexOf( ADynamic ) > -1;
			case 1: 
				switch (cfield.kind) {
					case FVar(AccResolve, _) | FVar(_, AccResolve) | FVar(AccResolve, AccResolve): true;
					case FMethod(MethDynamic): true;
					case _: false;
				}
			case _: null;
		}
	}
	
	private function set_isDynamic(v:Bool):Bool {
		switch(fkind) {
			case 0: v ? efield.access.push( ADynamic ) : while (isDynamic) efield.access.remove( ADynamic );
			case 1: v;
			case _: null;
		}
		
		return v;
	}
	
	private function get_isMacro():Bool {
		return switch(fkind) {
			case 0: efield.access.indexOf( AMacro ) > -1;
			case 1: 
				switch (cfield.kind) {
					case FMethod(MethMacro): true;
					case _: false;
				}
			case _: null;
		}
	}
	
	private function set_isMacro(v:Bool):Bool {
		switch (fkind) {
			case 0: v ? efield.access.push( AMacro ) : while (isMacro) efield.access.remove( AMacro );
			case 1: v;
			case _: null;
		}
		return v;
	}
	
	private function get_isInline():Bool {
		return switch(fkind) {
			case 0: efield.access.indexOf( AInline ) > -1;
			case 1: 
				switch (cfield.kind) {
					case FVar(AccInline, _) | FVar(_, AccInline) | FVar(AccInline, AccInline): true;
					case FMethod(MethInline): true;
					case _: false;
				}
			case _: null;
		}
	}
	
	private function set_isInline(v:Bool):Bool {
		switch (fkind) {
			case 0: v ? efield.access.push( AInline ) : while (isInline) efield.access.remove( AInline );
			case 1: v;
			case _: null;
		}
		return v;
	}
	
	private function get_isProperty():Bool {
		return switch(fkind) {
			case 0: switch(efield.kind) { case FProp(_, _, _, _): true; case _: false; };
			case 1: 
				switch (cfield.kind) {
					case FVar(AccCall, _) | FVar(_, AccCall) | FVar(AccCall, AccCall): true;
					case FVar(AccRequire(_, _), _) | FVar(_, AccRequire(_, _)) | FVar(AccRequire(_, _), AccRequire(_, _)): true;
					case _: false;
				}
			case _: null;
		}
	}
	
	private function get_isVar():Bool {
		return switch(fkind) {
			case 0: switch(efield.kind) { case FVar(_, _): true; case _: false; };
			case 1: 
				switch (cfield.kind) {
					case FVar(AccNormal, _) | FVar(_, AccNormal) | FVar(AccNormal, AccNormal): true;
					case _: false;
				}
			case _: null;
		}
	}
	
	private function get_isMethod():Bool {
		return switch(fkind) {
			case 0: switch(efield.kind) { case FFun(_): true; case _: false; };
			case 1: 
				switch (cfield.kind) {
					case FMethod(_): true;
					case _: false;
				}
			case _: null;
		}
	}
	
	private function get_typeof():Type {
		var result = null;
		
		switch (fkind) {
			case 0: 
				switch (efield.kind) {
					case FVar(t, _):
						result = t.toType();
						
					case FProp(_, _, t, _):
						result = t.toType();
						
					case FFun(method):
						result = TFun( [for (a in method.args) { name: a.name, opt: a.opt, t: a.type.toType() }], method.ret.toType() );
						
				}
			
			case 1: result = cfield.type;
			case _: null;
		}
		
		return result;
	}
	
	// -- internal
	
}