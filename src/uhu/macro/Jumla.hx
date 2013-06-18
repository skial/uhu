package uhu.macro;

import Type in StdType;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

typedef JumlaTypePrinter = uhu.macro.jumla.type.TypePrinter;
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
typedef JumlaTFunTools = uhu.macro.jumla.type.TFunTools;

typedef JumlaExprPrinter = uhu.macro.jumla.expr.ExprPrinter;
typedef JumlaExprTools = uhu.macro.jumla.ExprTools;
typedef JumlaComplexTypeTools = uhu.macro.jumla.ComplexTypeTools;
typedef JumlaEVarTools = uhu.macro.jumla.expr.EVarTools;
typedef JumlaFieldTools = uhu.macro.jumla.expr.FieldTools;
typedef JumlaConstantTools = uhu.macro.jumla.expr.ConstantTools;
typedef JumlaFunctionTools = uhu.macro.jumla.expr.FunctionTools;
typedef JumlaFunctionArgTools = uhu.macro.jumla.expr.FunctionArgTools;
typedef JumlaMetadataEntryTools = uhu.macro.jumla.expr.MetadataEntryTools;
typedef JumlaTypeDefinitionTools = uhu.macro.jumla.expr.TypeDefinitionTools;

typedef JumlaCommon = uhu.macro.jumla.Common;

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
	
}