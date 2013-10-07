package uhx.lexer;

import byte.ByteData;
import haxe.io.Eof;
import haxe.rtti.Meta;
import hxparse.Parser;
import hxparse.ParserBuilder;
import sys.io.File;
import uhx.mo.Token;
import uhx.mo.TokenDef;
import uhx.lexer.HaxeLexer.HaxeKeywords;
import de.polygonal.core.fmt.ASCII;

/**
 * ...
 * @author Skial Bainn
 */
class HaxeParser {

	private var result:StringBuf;
	private var lexer:HaxeLexer;
	
	public function new() {
		
	}
	
	public function tokenise(input:ByteData, name:String):Array<Token<HaxeKeywords>> {
		var results = [];
		
		lexer = new HaxeLexer( input, name );
		
		try {
			
			while ( true ) {
				var token = lexer.token( HaxeLexer.root );
				results.push( token );
			}
			
		} catch (e:Dynamic) { }
		
		return results;
	}
	
	public function htmlify(tokens:Array<Token<HaxeKeywords>>) {
		result = new StringBuf();
		
		result.add('<pre><code class="language haxe">');
		
		for (token in tokens) {
			
			var name = Mo.cssify( token.token );
			
			switch( token.token ) {
				case At: add( '@', name );
				case Dot: add( '.', name );
				case Colon: add( ':', name );
				case Arrow: add( '->', name );
				case Comma: add( ',', name );
				case Question: add( '?', name );
				case Semicolon: add( ';', name );
				case Newline: add( '\n', name );
				case Carriage: add( '\r', name );
				case BracketOpen: add( '[', name );
				case BracketClose: add( ']', name );
				case BraceOpen: add( '{', name );
				case BraceClose: add( '}', name );
				case ParenthesesOpen: add( '(', name );
				case ParenthesesClose: add( ')', name );
				case Tab(n): for (i in 0...n) add( '\t', name );
				case Space(n): add( [for (i in 0...n) ' '].join(''), name );
				case EConst(CInt(v)): add( v, name );
				case EConst(CFloat(v)): add( v, name );
				case EConst(CString(v)): add( '"$v"', name );
				case EConst(CIdent(v)): add( v, name );
				case EUnop(OpIncrement): add( '++', name );
				case EUnop(OpDecrement): add( '--', name );
				case EUnop(OpNot): add( '!', name );
				case EUnop(OpNegBits): add( '~', name );
				case EBinop(OpAdd): add( '+', name );
				case EBinop(OpMult): add( '*', name );
				case EBinop(OpDiv): add( '/', name );
				case EBinop(OpSub): add( '-', name );
				case EBinop(OpAssign): add( '=', name );
				case EBinop(OpEq): add( '==', name );
				case EBinop(OpNotEq): add( '!=', name );
				case EBinop(OpGt): add( '>', name );
				case EBinop(OpGte): add( '>=', name );
				case EBinop(OpLt): add( '<', name );
				case EBinop(OpLte): add( '<=', name );
				case EBinop(OpAnd): add( '&', name );
				case EBinop(OpOr): add( '|', name );
				case EBinop(OpXor): add( '^', name );
				case EBinop(OpBoolAnd): add( '&&', name );
				case EBinop(OpBoolOr): add( '||', name );
				case EBinop(OpShl): add( '<<', name );
				case EBinop(OpShr): add( '>>', name );
				case EBinop(OpUShr): add( '>>>', name );
				case EBinop(OpMod): add( '%', name );
				case EBinop(OpInterval): add( '...', name );
				case EBinop(OpArrow): add( '=>', name );
				case Keyword(kwd): add( Std.string( kwd ).substr(3).toLowerCase(), name );
				case Conditional(s): add( '#' + s, name );
				case Dollar(s): add( '$' + s, name );
				case IntInterval(s): add( s, name );
				case Comment(c): add( '/*$c*/', name );
				case CommentLine(c): add( '//$c', name );
				case _: 
			}
			
		}
		
		result.add('</code></pre>');
		
		return result.toString();
	}
	
	private function add(v:String, ?cls:String = '') {
		if (cls != '') cls = ' $cls';
		result.add( '<span class="token$cls">$v</span>' );
	}
	
}