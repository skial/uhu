package uhx.mo;

import haxe.macro.Type;
import haxe.macro.Expr;

/**
 * ...
 * @author Skial Bainn
 */
enum TokenDef<Kwd> {
	@css(1, true) EConst(c:Constant);
	@css(1, true) EUnop(op:Unop);
	@css(1, true) EBinop(op:Binop);
	@css(0, true) Keyword(v:Kwd);
	EOF;
	Newline;
	Carriage;
	Tab(len:Int);
	Space(len:Int);
	Dot;
	Colon;
	@split @css(3) IntInterval(s:String);
	Comment(s:String);
	@split CommentLine(s:String);
	Arrow;					//	->
	Semicolon;
	Comma;
	@split BracketOpen;		//	[
	@split BracketClose;	//	]
	@split BraceOpen;		//	{
	@split BraceClose;		//	}
	@split ParenthesesOpen;//	(
	@split ParenthesesClose;//	)
	Question;
	At;
	Conditional(s:String);	//	#
	Dollar(s:String);		//	$
	SingleQuote;			//	'
	DoubleQuote;			//	"
}