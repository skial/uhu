package uhx.macro.jumla.expr;

import haxe.macro.Type;
import haxe.macro.Expr;
import uhx.macro.jumla.a.AField;
import uhx.macro.jumla.a.AFields;

using Lambda;
using uhx.macro.Jumla;
/**
 * ...
 * @author Skial Bainn
 */
class FieldTools {

	public static function sugar(t:Field):AField return t;
	
}

class ManyFieldTools {

	public static inline function sugar(t:Array<Field>):AFields return t;
	
	public static function exists(fields:Array<Field>, name:String):Bool {
		var result:Bool = false;
		
		for (field in fields) if (field.name == name) {
			result = true;
			break;
		}
		
		return result;
	}

	public static function get(fields:Array<Field>, name:String):Field {
		var result:Field = null;
		
		for (field in fields) if (field.name == name) {
			result = field;
			break;
		}
		
		return result;
	}
	
	public static function remove(fields:Array<Field>, name:String):Bool {
		return fields.remove( get( fields, name ) );
	}
	
}

class FieldCollection {
	
	public static function name(v:ManyFields, key:EReg):Array<AField> {
		return Lambda.filter(v.original, function(f) return key.match( f.name ) ).array();
	}
	
	public static function meta(v:ManyFields, key:String):Array<AField> {
		return Lambda.filter(v.original, function(f) return f.meta.exists( key ) ).array();
	}
	
	public static function access(v:ManyFields, key:Access):Array<AField> {
		return Lambda.filter(v.original, function(f) return f.access.exists( key ) ).array();
	}
	
	public static function kind(v:ManyFields, key:FieldType):Array<AField> {
		return Lambda.filter(v.original, function(f) {
			var result = false;
			
			switch ([f.kind, key]) {
				case [FVar(_, _), FVar(_, _)]: result = true;
				case [FProp(_, _, _, _), FProp(_, _, _, _)]: result = true;
				case [FFun(_), FFun(_)]: result = true;
				case _:
			}
			
			return result;
		} ).array();
	}
	
	public static function type(v:ManyFields, key:ComplexType):Array<AField> {
		return Lambda.filter(v.original, function(f) {
			var result = false;
			
			var ctype = switch (f.kind) {
				case FVar(ctype, _): ctype;
				case FProp(_, _, ctype, _): ctype;
				case FFun(m): m.ret;
			}
			
			if (ctype != null) {
				
				switch ([ctype, key]) {
					case [TPath( { name:n1, pack:p1, params:_ } ), TPath( { name:n2, pack:p2, params:_ } )]:
						result = p1.concat([n1]).join('.') == p2.concat([n2]).join('.');
						
					case [TAnonymous(f1), TAnonymous(f2)]:
						result = true;
						for (f in f2) if (!f1.exists( f.name )) {
							result = false;
							break;
						}
						
					case _:
						trace( [ctype, key] );
				}
				
			}
			
			return result;
		} ).array();
	}
	
	public static function getter(v:ManyFields, key:String):Array<AField> {
		return Lambda.filter(v.original, function(f) {
			var result = false;
			
			switch (f.kind) {
				case FProp(g, _, _, _): result = g == key;
				case _:
			}
			
			return result;
		} ).array();
	}
	
	public static function setter(v:ManyFields, key:String):Array<AField> {
		return Lambda.filter(v.original, function(f) {
			var result = false;
			
			switch (f.kind) {
				case FProp(_, s, _, _): result = s == key;
				case _:
			}
			
			return result;
		} ).array();
	}
	
}