package uhu.macro;

import Type in StdType;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

typedef TField = uhu.macro.jumla.t.TField;
typedef JumlaTFieldTools = uhu.macro.jumla.TFieldTools;
typedef JumlaPrinter = uhu.macro.jumla.Printer;
typedef TComplexString = uhu.macro.jumla.t.TComplexString;
typedef JumlaComplexString = uhu.macro.jumla.ComplexStringTools;
typedef JumlaComplexTypeTools = uhu.macro.jumla.ComplexTypeTools;

typedef JumlaTypeTools = uhu.macro.jumla.TypeTools;
typedef JumlaTypePathTools = uhu.macro.jumla.TypePathTools;
typedef JumlaTypeParamTools = uhu.macro.jumla.TypeParamTools;
typedef JumlaBaseTypeTools = uhu.macro.jumla.type.BaseTypeTools;
typedef JumlaAnonymousTools = uhu.macro.jumla.type.AnonymousTools;
typedef JumlaClassTypeTools = uhu.macro.jumla.type.ClassTypeTools;
typedef JumlaClassFieldTools = uhu.macro.jumla.type.ClassFieldTools;
typedef JumlaEnumTypeTools = uhu.macro.jumla.type.EnumTypeTools;
typedef JumlaEnumFieldTools = uhu.macro.jumla.type.EnumFieldTools;
typedef JumlaTypedefTools = uhu.macro.jumla.type.TypedefTools;
typedef JumlaFieldKindTools = uhu.macro.jumla.type.FieldKindTools;
typedef JumlaVarAccessTools = uhu.macro.jumla.type.VarAccessTools;
typedef JumlaMethodKindTools = uhu.macro.jumla.type.MethodKindTools;

typedef JumlaExprTools = uhu.macro.jumla.ExprTools;
typedef JumlaEVarTools = uhu.macro.jumla.expr.EVarTools;
typedef JumlaConstantTools = uhu.macro.jumla.expr.ConstantTools;
typedef JumlaEFunctionTools = uhu.macro.jumla.expr.EFunctionTools;
typedef JumlaFieldTools = uhu.macro.jumla.expr.FieldTools;
typedef JumlaFunctionTools = uhu.macro.jumla.expr.FunctionTools;
typedef JumlaFunctionArgTools = uhu.macro.jumla.expr.FunctionArgTools;
typedef JumlaTypeDefinitionTools = uhu.macro.jumla.expr.TypeDefinitionTools;
typedef JumlaMetadataEntryTools = uhu.macro.jumla.expr.MetadataEntryTools;

/**
 * ...
 * @author Skial Bainn
 */
 
/**
 * Swahili for macro, I think
 */
class Jumla {
	
	// Random
	#if macro
	@:extern public static inline function toExpr(value:Dynamic, ?pos:Position) {
		return Context.makeExpr(value, pos);
	}
	#end
	
	public static function remove< T: { name:String } >(obj:Array<T>, key:String):Bool {
		var result = false;
		var target = null;
		
		if (obj != null && obj.length > 0) {
			
			for (o in obj) {
				
				if (o.name == key) {
					target = o;
					break;
				}
				
			}
			
			if (target != null) {
				result = obj.remove( target );
			}
			
		}
		
		return result;
	}
	
	public static function get< T: { name:String } >(obj:Array<T>, key:String):T {
		var result = null;
		
		if (obj != null && obj.length > 0) {
			
			for (o in obj) {
				
				if (o.name == key) {
					result = o;
					break;
				}
				
			}
			
		}
		
		return result;
	}
	
	public static function exists< T: { name:String } >(obj:Array<T>, key:String):Bool {
		var result = false;
		
		if (obj != null && obj.length > 0) {
			
			for (o in obj) {
				
				if (o.name == key) {
					
					result = true;
					break;
					
				}
				
			}
			
		}
		
		return result;
	}
	
	public static function getAll< T: { name:String } >(obj:Array<T>, key:String):Array<T> {
		var result:Array<T> = [];
		
		if (obj != null && obj.length > 0) {
			
			for (o in obj) {
				
				if (o.name == key) {
					result.push( o );
				}
				
			}
			
		}
		
		return result;
	}
	
}