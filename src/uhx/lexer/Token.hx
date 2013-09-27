package uhx.lexer;

import haxe.ds.Option;
import haxe.macro.Expr;
import haxe.macro.Type;
import hxparse.Position;

/**
 * ...
 * @author Skial Bainn
 */
class Token<Kwd> {
	
	public var token:TokenDef<Kwd>;
	public var position:Position;
	
	public function new(tok:TokenDef<Kwd>, pos:Position) {
		token = tok;
		position = pos;
		isKeyword = kwd;
	}
}

enum TokenDef<Kwd> {
	EConst(c:Constant);
	EUnop(op:Unop);
	EBinop(op:Binop);
	Keyword(v:Kwd);
	EOF;
	Newline;
	Carriage;
	Tab(len:Int);
	Space(len:Int);
	Dot;
	Colon;
	IntInterval(s:String);
	Comment(s:String);
	CommentLine(s:String);
	Arrow;			//	->
	Semicolon;
	Comma;
	BracketOpen;	//	[
	BracketClose;	//	]
	BraceOpen;		//	{
	BraceClose;	//	}
	ParenthesesOpen;//	(
	ParenthesesClose;//	)
	Question;
	At;
	Hash(s:String);	//	#
	Dollar(s:String);//	$
}