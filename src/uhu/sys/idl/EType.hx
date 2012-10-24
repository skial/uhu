package uhu.sys.idl;

/**
 * ...
 * @author Skial Bainn
 */

enum EType {
	Unknown(value:String);
	Comment(text:String);
	TypeParam(value:String);
	Name(text:String);
	Access(value:EAccess);
	Meta(value:Array<TMeta>);
	Section(tokens:Array<EType>, markers:Array<{index:Int, next:EPosition}>);
}

enum EAccess {
	Cls;
	Interface;
	Implements;
	Extends;
	Inline;
	Extern;
}

typedef TMeta = {
	@:optional var name:String;
	@:optional var value:String;
	var isCompiler:Bool;
}

enum EPosition {
	Next;
	Prev;
	End;
	To(value:Int);
}