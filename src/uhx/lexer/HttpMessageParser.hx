package uhx.lexer;

import uhx.mo.Token;
import byte.ByteData;
import haxe.ds.StringMap;
import uhx.lexer.HttpMessageLexer;

using StringTools;

/**
 * ...
 * @author Skial Bainn
 */
class HttpMessageParser {
	
	private var result:StringBuf;
	private var lexer:HttpMessageLexer;

	public function new() {
		
	}
	
	public function tokenise(input:ByteData, name:String):Array<Token<HttpMessageKeywords>> {
		var results = [];
		
		lexer = new HttpMessageLexer( input, name );
		
		try while (true) {
			var token = lexer.token( HttpMessageLexer.root );
			results.push( token );
			
		} catch (e:Dynamic) { }
		
		return results;
	}
	
	public function toMap(tokens:Array<Token<HttpMessageKeywords>>):StringMap<String> {
		var result = new StringMap<String>();
		var iterator = tokens.iterator();
		var current = null;
		
		try for (token in tokens) {
			
			switch (token.token) {
				case Keyword( KwdHttp( version ) ): 
					result.set( 'http', version );
					
				case Keyword( KwdStatus(code, status) ):
					result.set( 'code', '' + code );
					result.set( 'status', status );
					
				case Keyword( KwdHeader( name, value ) ):
					result.set( name.toLowerCase(), value.trim() );
					
				case _:
					
					
			}
			
		} catch (e:Dynamic) { }
		
		return result;
	}
	
}