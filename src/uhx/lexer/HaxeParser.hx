package uhx.lexer;

import byte.ByteData;
import haxe.io.Eof;
import hxparse.Parser;
import hxparse.ParserBuilder;
import uhx.lexer.Token;
import uhx.lexer.HaxeLexer.HaxeKeywords;

/**
 * ...
 * @author Skial Bainn
 */
class HaxeParser {

	private var lexer:HaxeLexer;
	
	public function new(input:ByteData, name:String) {
		var tokens = tokenise( input, name );
		trace( htmlify( tokens ) );
	}
	
	public function tokenise(input:ByteData, name:String):Array<Token<HaxeKeywords>> {
		var results = [];
		
		lexer = new HaxeLexer( input, name );
		
		try {
			
			while ( true ) {
				var token = lexer.token( HaxeLexer.root );
				results.push( token );
			}
			
		} catch (e:Eof) {
			
			trace(' EOF!!! ');
			trace( e );
			
		} catch (e:Dynamic) {
			
			trace( e );
			
		}
		
		return results;
	}
	
	public function htmlify(tokens:Array<Token<HaxeKeywords>>) {
		var result = new StringBuf();
		
		for (token in tokens) {
			
			switch( token.token ) {
				case At: result.add( '@' );
				case Dot: result.add( '.' );
				case Colon: result.add( ':' );
				case Arrow: result.add( '->' );
				case Comma: result.add( ',' );
				case Question: result.add( '?' );
				case Semicolon: result.add( ';' );
				case Newline: result.add( '\n' );
				case Carriage: result.add( '\r' );
				case BracketOpen: result.add( '[' );
				case BracketClose: result.add( ']' );
				case BraceOpen: result.add( '{' );
				case BraceClose: result.add( '}' );
				case ParenthesesOpen: result.add( '(' );
				case ParenthesesClose: result.add( ')' );
				case Tab(n): for (i in 0...n) result.add( '\t' );
				case Space(n): for (i in 0...n) result.add( ' ' );
				case EConst(CInt(v)): result.add( v );
				case EConst(CFloat(v)): result.add( v );
				case EConst(CString(v)): result.add( '"$v"' );
				case EConst(CIdent(v)): result.add( v );
				case EUnop(OpIncrement): result.add( '++' );
				case EUnop(OpDecrement): result.add( '--' );
				case EUnop(OpNot): result.add( '!' );
				case EUnop(OpNegBits): result.add( '~' );
				case EBinop(OpAdd): result.add( '+' );
				case EBinop(OpMult): result.add( '*' );
				case EBinop(OpDiv): result.add( '/' );
				case EBinop(OpSub): result.add( '-' );
				case EBinop(OpAssign): result.add( '=' );
				case EBinop(OpEq): result.add( '==' );
				case EBinop(OpNotEq): result.add( '!=' );
				case EBinop(OpGt): result.add( '>' );
				case EBinop(OpGte): result.add( '>=' );
				case EBinop(OpLt): result.add( '<' );
				case EBinop(OpLte): result.add( '<=' );
				case EBinop(OpAnd): result.add( '&' );
				case EBinop(OpOr): result.add( '|' );
				case EBinop(OpXor): result.add( '^' );
				case EBinop(OpBoolAnd): result.add( '&&' );
				case EBinop(OpBoolOr): result.add( '||' );
				case EBinop(OpShl): result.add( '<<' );
				case EBinop(OpShr): result.add( '>>' );
				case EBinop(OpUShr): result.add( '>>>' );
				case EBinop(OpMod): result.add( '%' );
				case EBinop(OpInterval): result.add( '...' );
				case EBinop(OpArrow): result.add( '=>' );
				case Keyword(kwd): result.add( Std.string( kwd ).substr(3).toLowerCase() );
				case Hash(s): result.add( '#' + s );
				case Dollar(s): result.add( '$' + s );
				case IntInterval(s): result.add( s );
				case Comment(c): result.add( '/*$c*/' );
				case CommentLine(c): result.add( '//$c' );
				case _: 
			}
			
		}
		
		return result.toString();
	}
	
}