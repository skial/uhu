package uhu.macro.jumla.t;

import haxe.macro.Type;
import haxe.macro.Expr;

/**
 * @author Skial Bainn
 */

typedef TField = {
	var name:String;
	var pos:Position;
	
	var access:Array<Access>;
	@:optional var kind:FieldType;
}

// haxe.macro.Type
/*typedef ClassField = {
	var name : String;
	var type : Type;
	var isPublic : Bool;
	var params : Array<{ name : String, t : Type }>;
	var meta : MetaAccess;
	var kind : FieldKind;
	function expr() : Null<TypedExpr>;
	var pos : Expr.Position;
	var doc : Null<String>;
}*/

// haxe.macro.Expr
/*typedef Field = {
	var name : String;
	@:optional var doc : Null<String>;
	@:optional var access : Array<Access>;
	var kind : FieldType;
	var pos : Position;
	@:optional var meta : Metadata;
}*/