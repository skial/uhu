package uhu.macro.jumla;

import haxe.macro.Type;
import haxe.macro.Expr;
import uhu.macro.jumla.t.TComplexString;
import uhu.macro.jumla.t.TField;

/**
 * @author Skial Bainn
 */

class TypeTools {
	
	// Compat code for tink_macros
	@:extern public static inline function getID(type:Type, ?reduce:Bool = false) {
		return getName(type);
	}
	
	public static inline function toString(t:Type):String {
		return getName( t );
	}
	
	public static function getName(type:Type):String {
		switch (type) {
			case TInst(t, _):
				return t.toString();
			case TEnum(t, _):
				return t.toString();
			case TType(t, _):
				return t.toString();
			#if haxe3
			case TAbstract(t, _):
				return t.toString();
			#end
			default:
				
		}
		
		return '';
	}
	
	public static function toTField(field:ClassField, isStatic:Bool):TField {
		var result = {
			name:'',
			pos:null,
			access:[],
			kind:null,
		}
		
		result.name = field.name;
		result.pos = field.pos;
		
		if (isStatic) {
			result.access.push(AStatic);
		}
		
		var read:String = null;
		var write:String = null;
		
		switch (field.kind) {
			case FVar(r, w):
				
				result.kind = FVar( null, null );
				
				switch (r) {
					case AccInline:
						result.access.push( AInline );
					case AccResolve:
						result.access.push( ADynamic );
					case AccCall( m ):
						read = m;
					case _:
				}
				
				switch (w) {
					case AccCall( m ):
						write = m;
					case _:
				}
				
			case FMethod(k):
				
				result.kind = FFun( null );
				
				switch (k) {
					case MethInline:
						result.access.push( AInline );
					case MethMacro:
						result.access.push( AMacro );
					case _:
				}
		}
		
		if (read != null || write != null) {
			
			read = read == null ? 'default' : read;
			write = write == null ? 'default' : write;
			
			result.kind = FProp( read, write, null, null );
			
		}
		
		return result;
	}
	
	public static function toTFields(fields:Array<ClassField>, isStatic:Bool):Array<TField> {
		var result = [];
		
		for (field in fields) {
			result.push( toTField( field, isStatic ) );
		}
		
		return result;
	}
	
}