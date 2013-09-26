package uhx.lexer;

import byte.ByteData;
import hxparse.Lexer;
import hxparse.RuleBuilder;
import haxe.macro.Expr;
import uhx.lexer.Token;

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
	
	public static var idtype:String = '_*[A-Z][_a-zA-Z0-9]*';
	public static var ident:String = '_*[a-z][_a-zA-Z0-9]*|_+[0-9][_a-zA-Z0-9]*|' + idtype + '|_+|\\$[_a-zA-Z0-9]+';
	
	public static function create<T>(lex:Lexer, tok:T):Token<T> {
		return new Token<T>(tok, lex.curPos());
	}
	
	public static var root = @:rule [
		'' => create(lexer, EOF),
		
	];
	
}