package example.hxparse;
import haxe.io.Input;
import hxparse.Lexer;
import hxparse.Parser;
import hxparse.RuleBuilder;
import hxparse.LexerStream;
import hxparse.Types;

/**
 * ...
 * @author Skial Bainn
 */
class MuLexer extends Lexer implements RuleBuilder {

	public static var OTAG:String = '{{';
	public static var CTAG:String = '}}';
	
	public static var OPEN:String = OTAG;
	public static var CLOSE:String = CTAG;
	
	public static var tag_ident:String = '[a-zA-Z0-9. ]+';
	
	public static var outside = Lexer.build( [
		{ 
			rule: OPEN, 
			func: function(lexer) return lexer.token(tag) 
		},
		{ 
			rule: '[a-z0-9A-Z\r\n\t_<>#//=". ]+', 
			func: function(lexer) return Static(lexer.current) 
		},
		{ 
			rule: CLOSE, 
			func: function(lexer) return Static('') 
		},
	] );
	
	public static var tag = Lexer.build( [
		{ 
			rule: tag_ident, 
			func: function(lexer) {
				return Normal(lexer.current);
			}
		},
		{ 
			rule: '[&{]' + tag_ident,
			func: function(lexer) {
				return Unescaped(lexer.current);
			}
		},
		{ 
			rule: '#' + tag_ident, 
			func: function(lexer) {
				var name = lexer.current;
				var section = name.substr(1);
				var tokens = [];
				while (true) {
					tokens.push( lexer.token(outside) );
					if (lexer.current == '/' + section) {
						break;
					}
				};
				return Section(name.substr(1), true, tokens);
			}
		},
		{ 
			rule: '^' + tag_ident, 
			func: function(lexer) {
				var name = lexer.current;
				var section = name.substr(1);
				var tokens = [];
				while (true) {
					tokens.push( lexer.token(outside) );
					if (lexer.current == '/' + section) {
						break;
					}
				};
				return Section(name.substr(1), false, tokens);
			}
		},
		{ 
			rule: '!' + tag_ident, 
			func: function(lexer) return Comment(lexer.current)
		},
		{ 
			rule: '=' + tag_ident, 
			func: function(lexer) return Delimiter(lexer.current, OPEN, CLOSE)
		},
		{ 
			rule: '>' + tag_ident, 
			func: function(lexer) return Partial(lexer.current, [])
		},
		{ 
			rule: '/' + tag_ident, 
			func: function(lexer) {
				return Close(lexer.current);
			}
		},
		{ 
			rule: CLOSE, 
			func: function(lexer) return Static('') 
		},
	] );
	
	public static var in_tag = Lexer.build( [
		{ 
			rule: '[a-zA-Z0-9 ]+', 
			func: function(lexer) return Static(lexer.current) 
		},
	] );
	
}

enum EMu {
	// Anything
	Static(v:String);
	
	// [a-zA-Z0-9. ]
	Normal(v:String);
	
	// & or {
	Unescaped(v:String);
	
	// #
	Section(v:String, truthy:Bool, tokens:Array<EMu>);
	
	// !
	Comment(v:String);
	
	// =
	Delimiter(v:String, otag:String, ctag:String);
	
	// >
	Partial(v:String, tokens:Array<EMu>);
	
	// Marks the end of a section
	Close(v:String);
}

class MuParser {
	public var out:StringBuf;
	public function print(t:EMu) {
		switch (t) {
			case Close(v):
				out.add('{{' + v + '}}');
				
			case Static(v):
				out.add(v);
				
			case Normal(v), Comment(v):
				out.add('{{' + v + '}}');
				
			case Section(v, b, t):
				out.add('{{' + v + '}}');
				for (tt in t) print( tt );
				
			case _:
		}
	}
	
	public function new(input:Input) {
		var l = new MuLexer( input );
		out = new StringBuf();
		
		try {
			while ( true ) {
					print( l.token(MuLexer.outside) );
			}
		} catch (e:Dynamic) {
			trace( e );
		}
		
		trace( out.toString() );
	}
	
}