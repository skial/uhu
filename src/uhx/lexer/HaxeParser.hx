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
		for (token in tokens) trace( token );
		trace( tokens.length );
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
	
	public function parse() {
		
	}
	
}