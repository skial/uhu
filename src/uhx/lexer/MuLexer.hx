package uhx.lexer;

import uhx.lexer.impl.e.EMu;
import haxe.ds.Option;
import haxe.io.Input;
import hxparse.Lexer;
import hxparse.RuleBuilder;

using StringTools;
using haxe.EnumTools;

/**
 * ...
 * @author Skial Bainn
 */
class MuLexer extends Lexer {
	
	public static var space:String = ' ';
	public static var slash:String = '\\\\';
	public static var az:String = 'a-z';
	public static var AZ:String = 'A-Z';
	public static var num:String = '0-9';
	public static var nsym:String = "'_,><#|!.=/";
	public static var esym:String = '"\\*\\-';
	
	// Switching \\\\ to \\ kills chrome and firefox...
	public static var re:String = '\r|\\\\r';
	public static var newline:String = '\n|\\\\n';
	public static var tab:String = '\t|\\\\t';
	
	public static var tag_ident:String = '[$az$AZ$num$re$newline$tab$nsym$esym$space]+';
	
	public static var OTAG:String = '{{';
	public static var CTAG:String = '}}';
	
	public static var OPEN:String = OTAG;
	public static var CLOSE:String = CTAG;
	
	public static var isStandalone:Bool = false;
	
	public static var outside = Lexer.buildRuleset( [
		{ 
			rule: OPEN, 
			func: function(lexer) {
				return lexer.token(tag);
			}
		},
		{ 
			rule: '[$az$AZ$num$nsym$esym]*', 
			func: function(lexer) {
				return Static(lexer.current);
			}
		},
		{ 
			rule: '$space*',
			func: function(lexer) {
				return Space(lexer.current);
			}
		},
		/*{ 
			rule: '$re*',
			func: function(lexer) {
				return Carriage(lexer.current);
			}
		},*/
		{ 
			rule: '($re)*($newline)*',
			func: function(lexer) {
				return Newline(lexer.current);
			}
		},
		{ 
			rule: '$tab*',
			func: function(lexer) {
				return Tab(lexer.current);
			}
		},
		{ 
			rule: CLOSE, 
			func: function(lexer) {
				return lexer.token( outside );
			}
		},
	] );
	
	public static var tag = Lexer.buildRuleset( [
		{ 
			rule: tag_ident, 
			func: function(lexer) {
				return Normal(lexer.current);
			}
		},
		{ 
			rule: '[&{]' + tag_ident + '[}]?',
			func: function(lexer) {
				var name = lexer.current.substr(1);
				return Unescaped(name.endsWith('}') ? name.substr(0, -1) : name);
			}
		},
		{ 
			rule: '#' + tag_ident, 
			func: function(lexer) {
				var name = lexer.current;
				var section = name.substr(1);
				var tokens:Array<EMu> = [];
				while (true) {
					tokens.push( lexer.token(outside) );
					if (Type.enumEq( tokens[tokens.length - 1], Close( section ) )) {
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
			func: function(lexer) {
				return Comment(lexer.current);
			}
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
				return Close(lexer.current.substr(1));
			}
		},
	] );
	
}