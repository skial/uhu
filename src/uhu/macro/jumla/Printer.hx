package uhu.macro.jumla;

import haxe.macro.Expr;

/**
 * @author Skial Bainn
 */

class Printer {
	
	/**
	 * Just so I can use `using`
	 */
	
	private static var printer:haxe.macro.Printer = new haxe.macro.Printer();
	
	public static function printUnop(op:Unop) return printer.printUnop( op );
	public static function printBinop(op:Binop) return printer.printBinop( op );
	public static function printConstant(c:Constant) return printer.printConstant( c );
	public static function printTypeParam(p:TypeParam) return printer.printTypeParam( p );
	public static function printTypePath(p:TypePath) return printer.printTypePath( p );
	public static function printComplexType(c:ComplexType) return printer.printComplexType( c );
	public static function printMetadata(m:MetadataEntry) return printer.printMetadata( m );
	public static function printAccess(a:Access) return printer.printAccess( a );
	public static function printField(f:Field) return printer.printField( f );
	public static function printTypeParamDecl(t:TypeParamDecl) return printer.printTypeParamDecl( t );
	public static function printFunctionArg(a:FunctionArg) return printer.printFunctionArg( a );
	public static function printFunction(f:Function) return printer.printFunction( f );
	public static function printVar(v:Var) return printer.printVar( v );
	public static function printExpr(e:Expr) return printer.printExpr( e );
	public static function printExprs(a:Array<Expr>, s:String) return printer.printExprs( a, s );
	public static function printTypeDefinition(t:TypeDefinition, printPackage = true) return printer.printTypeDefinition( t, printPackage );
	
}