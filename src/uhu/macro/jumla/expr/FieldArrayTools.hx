package uhu.macro.jumla.expr;

import haxe.macro.Expr;

using uhu.macro.Jumla;
using haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class FieldArrayTools {

	public static function mkFields(na:Array<String>):Array<Field> {
		var result = [for (n in na) n.mkField()];
		return result;
	}
	
	public static function mkPublic(fs:Array<Field>):Array<Field> {
		for (f in fs) f.mkPublic();
		return fs;
	}
	
	public static function rmPublic(fs:Array<Field>):Array<Field> {
		for (f in fs) f.removeAccess( APublic );
		return fs;
	}
	
	public static function mkPrivate(fs:Array<Field>):Array<Field> {
		for (f in fs) f.addAccess( APrivate );
		return fs;
	}
	
	public static function rmPrivate(fs:Array<Field>):Array<Field> {
		for (f in fs) f.removeAccess( APrivate );
		return fs;
	}
	
	public static function mkStatic(fs:Array<Field>):Array<Field> {
		for (f in fs) f.addAccess( AStatic );
		return fs;
	}
	
	public static function rmStatic(fs:Array<Field>):Array<Field> {
		for (f in fs) f.removeAccess( AStatic );
		return fs;
	}
	
	public static function mkOverride(fs:Array<Field>):Array<Field> {
		for (f in fs) f.addAccess( AOverride );
		return fs;
	}
	
	public static function rmOverride(fs:Array<Field>):Array<Field> {
		for (f in fs) f.removeAccess( AOverride );
		return fs;
	}
	
	private static function mkDynamic(fs:Array<Field>):Array<Field> {
		for (f in fs) f.addAccess( ADynamic );
		return fs;
	}
	
	private static function rmDynamic(fs:Array<Field>):Array<Field> {
		for (f in fs) f.removeAccess( ADynamic );
		return fs;
	}
	
	public static function mkInline(fs:Array<Field>):Array<Field> {
		for (f in fs) f.addAccess( AInline );
		return fs;
	}
	
	public static function rmInline(fs:Array<Field>):Array<Field> {
		for (f in fs) f.removeAccess( AInline );
		return fs;
	}
	
	public static function mkMacro(fs:Array<Field>):Array<Field> {
		for (f in fs) f.addAccess( AMacro );
		return fs;
	}
	
	public static function rmMacro(fs:Array<Field>):Array<Field> {
		for (f in fs) f.removeAccess( AMacro );
		return fs;
	}
	
	public static function toFVar(fields:Array<Field>, t:ComplexType, e:Expr = null):Array<Field> {
		for (field in fields) field.kind = FVar(t, e);
		return fields;
	}
	
	public static function toFProp(fields:Array<Field>, g:String = 'default', s:String = 'default', t:ComplexType = null, e:Expr = null):Array<Field> {
		for (field in fields) field.kind = FProp(g, s, t, e);
		return fields;
	}
	
	public static function toFFun(fields:Array<Field>):Array<Field> {
		for (field in fields) {
			field.kind = FFun( {
				args: [],
				ret: null,
				expr: null,
				params: []
			} );
		};
		return fields;
	}
	
	public static function addMeta(fs:Array<Field>, meta:MetadataEntry):Array<Field> {
		for (f in fs) {
			if (f.meta == null) f.meta = [];
			f.meta.push( meta );
		}
		return fs;
	}
	
}