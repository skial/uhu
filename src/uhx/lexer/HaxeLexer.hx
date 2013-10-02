package uhx.lexer;

import byte.ByteData;
import haxe.io.Eof;
import hxparse.Lexer;
import hxparse.RuleBuilder;
import uhx.mo.Token;
import uhx.mo.TokenDef;

enum HaxeKeywords {
	@css(3) KwdFunction;
	@css(3) KwdClass;
	@css(3) KwdVar;
	@css(3) KwdIf;
	@css(3) KwdElse;
	@css(3) KwdWhile;
	@css(3) KwdDo;
	@css(3) KwdFor;
	@css(3) KwdBreak;
	@css(3) KwdContinue;
	@css(3) KwdReturn;
	@css(3) KwdExtends;
	@css(3) KwdImplements;
	@css(3) KwdImport;
	@css(3) KwdSwitch;
	@css(3) KwdCase;
	@css(3) KwdDefault;
	@css(3) KwdStatic;
	@css(3) KwdPublic;
	@css(3) KwdPrivate;
	@css(3) KwdTry;
	@css(3) KwdCatch;
	@css(3) KwdNew;
	@css(3) KwdThis;
	@css(3) KwdThrow;
	@css(3) KwdExtern;
	@css(3) KwdEnum;
	@css(3) KwdIn;
	@css(3) KwdInterface;
	@css(3) KwdUntyped;
	@css(3) KwdCast;
	@css(3) KwdOverride;
	@css(3) KwdTypedef;
	@css(3) KwdDynamic;
	@css(3) KwdPackage;
	@css(3) KwdInline;
	@css(3) KwdUsing;
	@css(3) KwdNull;
	@css(3) KwdTrue;
	@css(3) KwdFalse;
	@css(3) KwdAbstract;
	@css(3) KwdMacro;
}

/**
 * ...
 * @author Skial Bainn
 */
class HaxeLexer extends Lexer implements BaseLexer implements RuleBuilder {
	
	public var lang:String;
	public var ext:Array<String>;
	//public var keywords:Array<String>;

	public function new(content:ByteData, name:String) {
		name = 'haxe';
		ext = ['hx'];
		
		/*keywords = ('function|class|static|var|if|else|while|do|for|'
            + 'break|return|continue|extends|implements|import|'
            + 'switch|case|default|public|private|try|untyped|'
            + 'catch|new|this|throw|extern|enum|in|interface|'
            + 'cast|override|dynamic|typedef|package|'
            + 'inline|using|null|true|false|abstract').split('|');
			*/
		super( content, name );
	}
	
	public static var buf = new StringBuf();
	public static var idtype:String = '_*[A-Z][_a-zA-Z0-9]*';
	public static var ident:String = '_*[a-z][_a-zA-Z0-9]*|_+[0-9][_a-zA-Z0-9]*|' + idtype + '|_+|\\$[_a-zA-Z0-9]+';
	//public static var ident:String = '_*[a-z][a-zA-Z0-9_]*|_+|_+[0-9][_a-zA-Z0-9]*';
	
	public static var keywords = @:mapping(3) HaxeKeywords;
	
	public static function mk<T>(lex:Lexer, tok:TokenDef<T>):Token<T> {
		return new Token<T>(tok, lex.curPos());
	}
	
	public static var root = @:rule [
		'\n' => mk(lexer, Newline),
		'\r' => mk(lexer, Carriage),
		'\t*' => mk(lexer, Tab(lexer.current.length)),
		' *' => mk(lexer, Space(lexer.current.length)),
		"0x[0-9a-fA-F]+" => mk(lexer, EConst(CInt(lexer.current))),
		"[0-9]+" => mk(lexer, EConst(CInt(lexer.current))),
		"[0-9]+.[0-9]+" => mk(lexer, EConst(CFloat(lexer.current))),
		".[0-9]+" => mk(lexer, EConst(CFloat(lexer.current))),
		"[0-9]+[eE][\\+\\-]?[0-9]+" => mk(lexer, EConst(CFloat(lexer.current))),
		"[0-9]+.[0-9]*[eE][\\+\\-]?[0-9]+" => mk(lexer, EConst(CFloat(lexer.current))),
		"[0-9]+..." => mk(lexer, IntInterval(lexer.current.substr(0,-3))),
		"//[^\n\r]*" => mk(lexer, CommentLine(lexer.current.substr(2))),
		"+\\+" => mk(lexer, EUnop(OpIncrement)),
		"--" => mk(lexer, EUnop(OpDecrement)),
		"~" => mk(lexer, EUnop(OpNegBits)),
		"%=" => mk(lexer, EBinop(OpAssignOp(OpMod))),
		"&=" => mk(lexer, EBinop(OpAssignOp(OpAnd))),
		"|=" => mk(lexer, EBinop(OpAssignOp(OpOr))),
		"^=" => mk(lexer, EBinop(OpAssignOp(OpXor))),
		"+=" => mk(lexer, EBinop(OpAssignOp(OpAdd))),
		"-=" => mk(lexer, EBinop(OpAssignOp(OpSub))),
		"*=" => mk(lexer, EBinop(OpAssignOp(OpMult))),
		"/=" => mk(lexer, EBinop(OpAssignOp(OpDiv))),
		"==" => mk(lexer, EBinop(OpEq)),
		"!=" => mk(lexer, EBinop(OpNotEq)),
		"<=" => mk(lexer, EBinop(OpLte)),
		"&&" => mk(lexer, EBinop(OpBoolAnd)),
		"|\\|" => mk(lexer, EBinop(OpBoolOr)),
		"<<" => mk(lexer, EBinop(OpShl)),
		"->" => mk(lexer, Arrow),
		"..." => mk(lexer, EBinop(OpInterval)),
		"=>" => mk(lexer, EBinop(OpArrow)),
		"!" => mk(lexer, EUnop(OpNot)),
		"<" => mk(lexer, EBinop(OpLt)),
		">" => mk(lexer, EBinop(OpGt)),
		";" => mk(lexer, Semicolon),
		":" => mk(lexer, Colon),
		"," => mk(lexer, Comma),
		"." => mk(lexer, Dot),
		"%" => mk(lexer, EBinop(OpMod)),
		"&" => mk(lexer, EBinop(OpAnd)),
		"|" => mk(lexer, EBinop(OpOr)),
		"^" => mk(lexer, EBinop(OpXor)),
		"+" => mk(lexer, EBinop(OpAdd)),
		"*" => mk(lexer, EBinop(OpMult)),
		"/" => mk(lexer, EBinop(OpDiv)),
		"-" => mk(lexer, EBinop(OpSub)),
		"=" => mk(lexer, EBinop(OpAssign)),
		"[" => mk(lexer, BracketOpen),
		"]" => mk(lexer, BracketClose),
		"{" => mk(lexer, BraceOpen),
		"}" => mk(lexer, BraceClose),
		"\\(" => mk(lexer, ParenthesesOpen),
		"\\)" => mk(lexer, ParenthesesClose),
		"?" => mk(lexer, Question),
		"@" => mk(lexer, At),
		"#" + ident => mk(lexer, Conditional(lexer.current.substr(1))),
		"$" + ident => mk(lexer, Dollar(lexer.current.substr(1))),
		'"' => {
			buf = new StringBuf();
			var pmin = lexer.curPos();
			var pmax = try lexer.token(string) catch (e:Eof) throw e;
			mk(lexer, EConst(CString(buf.toString())));
		},
		"'" => {
			buf = new StringBuf();
			var pmin = lexer.curPos();
			var pmax = try lexer.token(string2) catch (e:Eof) throw e;
			mk(lexer, EConst(CString(buf.toString())));
		},
		'/\\*' => {
			buf = new StringBuf();
			var pmin = lexer.curPos();
			var pmax = try lexer.token(comment) catch (e:Eof) throw e;
			mk(lexer, Comment(buf.toString()));
		},
		ident => {
			var kwd = keywords.get(lexer.current);
			if (kwd != null)
				mk(lexer, Keyword(kwd));
			else
				mk(lexer, EConst(CIdent(lexer.current)));
		},
		idtype => mk(lexer, EConst(CIdent(lexer.current))),
	];
	
	public static var string = @:rule [
		"\\\\\\\\" => {
			buf.add("\\");
			lexer.token(string);
		},
		"\\\\n" => {
			buf.add("\n");
			lexer.token(string);
		},
		"\\\\r" => {
			buf.add("\r");
			lexer.token(string);
		},
		"\\\\t" => {
			buf.add("\t");
			lexer.token(string);
		},
		"\\\\\"" => {
			buf.add('"');
			lexer.token(string);
		},
		'"' => lexer.curPos().pmax,
		"[^\\\\\"]+" => {
			buf.add(lexer.current);
			lexer.token(string);
		}
	];
	
	public static var string2 = @:rule [
		"\\\\\\\\" => {
			buf.add("\\");
			lexer.token(string2);
		},
		"\\\\n" =>  {
			buf.add("\n");
			lexer.token(string2);
		},
		"\\\\r" => {
			buf.add("\r");
			lexer.token(string2);
		},
		"\\\\t" => {
			buf.add("\t");
			lexer.token(string2);
		},
		'\\\\\'' => {
			buf.add('"');
			lexer.token(string2);
		},
		"'" => lexer.curPos().pmax,
		'[^\\\\\']+' => {
			buf.add(lexer.current);
			lexer.token(string2);
		}
	];
	
	public static var comment = @:rule [
		"*/" => lexer.curPos().pmax,
		"*" => {
			buf.add("*");
			lexer.token(comment);
		},
		"[^\\*]" => {
			buf.add(lexer.current);
			lexer.token(comment);
		}
	];
	
}