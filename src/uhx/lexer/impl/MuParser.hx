package uhx.lexer.impl;

import haxe.ds.StringMap.StringMap;
import haxe.io.Eof;
import haxe.io.StringInput;
import uhx.lexer.MuLexer;
import uhx.lexer.impl.e.EMu;

using Std;
using Reflect;
using StringTools;
using uhx.lexer.impl.MuParser;

/**
 * ...
 * @author Skial Bainn
 */
class MuParser {
	
	public static var lexer:MuLexer;

	public function new() {
		
	}
	
	public static function tokenize(input:String):Array<EMu> {
		var result = [];
		lexer = new MuLexer( byte.ByteData.ofString( input ) );
		
		try {
			
			while (true) {
				var token = lexer.token( MuLexer.outside );
				result.push( token );
			}
			
		} catch (e:Eof) {
			trace(input);
			trace(result);
		} catch (e:Dynamic) {
			// rawr!
			trace( e );
		}
		
		return result;
	}
	
	private static function isWhitespace(token:EMu):Bool {
		var result = false;
		
		switch (token) {
			case Newline(_), Tab(_), Space(_):
				result = true;
				
			case _:
				
		}
		
		return result;
	}
	
	private static function isTag(token:EMu):Bool {
		var result = false;
		
		switch (token) {
			case Normal(_), Unescaped(_), Comment(_), Section(_), Delimiter(_, _, _), Partial(_, _):
				result = true;
				
			case _:
				
		}
		
		return result;
	}
	
	private static inline function isNewline(token:EMu):Bool {
		return token.getName() == 'Newline';
	}
	
	private static inline function isStatic(token:EMu):Bool {
		return token.getName() == 'Static';
	}
	
	private static inline function isSpace(token:EMu):Bool {
		return token.getName() == 'Space';
	}
	
	private static function isStandalone(tokens:Array<EMu>):Bool {
		var result = true;
		var counter = 0;
		
		while (counter != tokens.length) {
			
			switch (tokens[counter]) {
				case Newline(_) if (counter != 0):
					break;
					
				case Normal(_), Unescaped(_), Static(_), Section(_, _, _), Close(_):
					result = false;
					break;
					
				case _:
			}
			
			counter++;
			
		}
		
		return result;
	}
	
	private static function isInterpolating(token:EMu):Bool {
		var result = false;
		
		switch (token) {
			case Normal(_), Unescaped(_): result = true;
			case _:
		}
		
		return result;
	}
	
	private static function exists(views:Array<Map<String, Dynamic>>, key:String):Bool {
		var result = false;
		
		for (view in views) {
			result = view.exists( key );
			
			if (result) break;
		}
		
		return result;
	}
	
	private static function get(views:Array<Map<String, Dynamic>>, key:String):Dynamic {
		var result = null;
		
		for (view in views) {
			result = view.get( key );
			
			if (result != null) break;
		}
		
		return result;
	}
	
	public static function render(tokens:Array<EMu>, views:Array<Map<String, Dynamic>>):StringBuf {
		var buffer = new StringBuf();
		var skipNewline = false;
		var skipWhitespace = false;
		var i = 0;
		while (i != tokens.length) {
			var token = tokens[i];
			var prev = i != 0 ? tokens[i - 1] : null;
			var next = i + 1 != tokens.length ? tokens[i + 1] : null;
			
			if (!token.isInterpolating() && (prev != null && prev.isNewline()) && (next != null && (next.isWhitespace() && next.getParameters()[0].length > 1))) {
				tokens[i + 1] = Static('');
			} else if (next != null && !next.isInterpolating() && token.isWhitespace()) {
				skipWhitespace = true;
			} else if (prev != null && prev.isNewline() && !token.isInterpolating()) {
				skipNewline = true;
			}
			
			switch ( token ) {
				case Static(v):
					buffer.add( v );
					
				case Normal(v):
					buffer.add( views.exists( v.trim() ) ? StringTools.htmlEscape( '' + views.get( v.trim() ), true ) : '' );
					
				case Unescaped(v):
					buffer.add( views.get( v.trim() ) );
					
				case Comment(_):
					
					
				case Section(v, b, ts):
					
					if (views.exists( v.trim() )) {
						
						var result = '';
						var value:Dynamic = views.get( v.trim() );
						var isArray = value.is( Array );
						var isBool = value.is( Bool );
						var isMap = value.is( StringMap );
						var isMethod = value.isFunction();
						
						if (isArray && value.length == 0 || isBool && value == false) b = false;
						
						if (b) {
							// true section
							var values:Array<Map<String, Dynamic>> = if (isArray) {
								value;
							} else if (isBool) {
								views;
							} else {
								[ value ];
							}
							
							if (values.length > 0) {
								
								for (v in values) {
									result += ts.render( values != views ? [v].concat( views ) : views ).toString();
								}
								
							}
							
						} else {
							// false section
							
							
						}
						
						buffer.add( result );
						
					}
					
				case Delimiter(v, o, c):
					
				case Partial(v, ts):
					
				case Close(_):
					
				case Space(v):
					if (!skipWhitespace) {
						buffer.add( v );
					} else {
						skipWhitespace = false;
					}
					
				case Newline(v):
					if (!skipNewline || !skipWhitespace) {
						buffer.add( v );
					}
					if (skipNewline) skipNewline = false;
					if (skipWhitespace) skipWhitespace = false;
					
				case Tab(v):
					if (!skipWhitespace) {
						buffer.add( v );
					} else {
						skipWhitespace = false;
					}
					
				//case _:
					
			}
			
			i++;
			
		}
		
		return buffer;
	}
	
	public function parse(input:String, view:Map<String, Dynamic>):String {
		var tokens = tokenize( input );
		var buffer = tokens.render( [view] );
		
		return buffer.toString();
	}
	
}