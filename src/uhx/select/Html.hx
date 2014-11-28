package uhx.select;

import haxe.io.Eof;
import uhx.mo.Token;
import byte.ByteData;
import dtx.mo.DOMNode;
import uhx.lexer.CssLexer;
import uhx.lexer.HtmlLexer;

using Std;
using Type;
using Reflect;
using StringTools;
using uhx.select.Html;

private typedef Tokens = Array<Token<HtmlKeywords>>;
private typedef Method = Token<HtmlKeywords>->Token<HtmlKeywords>->Tokens->Void;

/**
 * ...
 * @author Skial Bainn
 * ---
- [x] `*`
- [x] `#id`
- [x] `.class`
- [x] `type`
- [x] `type, type`
- [x] `type ~ type`
- [x] `type + type`
- [x] `type type`
- [x] `type > type`
- [x] `[name]`
- [x] `[name="value"]`
- [x] `[name*="value"]`
- [x] `[name^="value"]`
- [x] `[name$="value"]`
- [x] `[name~="value"]`
- [x] `[name|="value"]`
- [x] `[attr1=value][attr2|="123"][attr3*="bob"]`
# Level 2 - http://www.w3.org/TR/CSS21/selector.html
- [x] `:custom-pseudo`
- [x] `:first-child`
- [x] `:link`
- [ ] `:visited`
- [ ] `:hover`
- [ ] `:active`
- [ ] `:focus`
- [ ] `:lang`
- [ ] `:first-line`
- [ ] `:first-letter`
- [ ] `:before`
- [ ] `:after`
# Level 3 - http://www.w3.org/TR/css3-selectors/
- [ ] `:target`
- [x] `:enabled`
- [x] `:disabled`
- [ ] `:checked`
- [ ] `:indeterminate`
- [x] `:root`
- [x] `:nth-child(even)`
- [x] `:nth-child(odd)`
- [x] `:nth-child(n)`
- [x] `:nth-last-child`
- [x] `:nth-of-type`
- [x] `:nth-last-of-type`
- [x] `:last-child`
- [x] `:first-of-type`
- [x] `:last-of-type`
- [x] `:only-child`
- [x] `:only-of-type`
- [x] `:empty`
- [ ] `:not(selector)`
# Level 4 - http://dev.w3.org/csswg/selectors4/
- [ ] `:matches`
- [ ] `:has`
- [ ] `:any-link`
- [ ] `:scope`
- [ ] `:drop`
- [ ] `:current`
- [ ] `:past`
- [ ] `:future`
- [ ] `:read-only`
- [ ] `:read-write`
- [ ] `:placeholder-shown`
- [ ] `:default`
- [ ] `:valid`
- [ ] `:invalid`
- [ ] `:in-range`
- [ ] `:out-range`
- [ ] `:required`
- [ ] `:optional`
- [ ] `:user-error`
- [ ] `:blank`
 * ---
 */
 
class Html {
	
	private static var selectorLexer:CssLexer = null;

	private static function parse(selector:String):CssSelectors {
		var tokens = [];
		
		if (selectorLexer == null) {
			selectorLexer = new CssLexer( ByteData.ofString( selector ), 'html-selector' );
		} else untyped {
			// Reset the lexer instead of recreating it.
			selectorLexer.current = '';
			selectorLexer.input = ByteData.ofString( selector );
			selectorLexer.pos = 0;
		}
		
		try while ( true ) {
			tokens.push( selectorLexer.token( CssLexer.selectors ) );
		} catch (e:Eof) {
			
		} catch (e:Dynamic) {
			trace( e );
		}
		
		for (i in 0...tokens.length) switch(tokens[i]) {
			case Attribute(_, _, _) | Pseudo(_, _) | 
			Combinator(Attribute(_, _, _), _, _) | Combinator(Pseudo(_, _), _, _):
				tokens[i] = Combinator(Universal, tokens[i], None);
				
			case _:
				
		}
		
		return tokens.length > 1?Group(tokens):tokens[0];
	}
	
	public static function find(objects:Tokens, selector:String) {
		var css = selector.parse();
		var results = [];
		
		dummyRef.tokens = objects;
		
		for (object in objects) {
			results = results.concat( process( object, css ) );
		}
		
		return results;
	}
	
	private static var previous:CssSelectors = null;
	private static var dummyRef:HtmlR = new HtmlRef('!!IGNORE!!', new Map(), [ -1], [], null, true);
	
	private static function process(object:Token<HtmlKeywords>, token:CssSelectors, ?ignore:Bool = false, ?negative:Bool = false, ?parent:Token<HtmlKeywords> = null):Tokens {
		var ref:HtmlR = dummyRef;
		var results:Tokens = [];
		var children:Null<Tokens> = [];
		var condition:Bool = false;
		var action:Void->Void = function() results.push( object );
		
		switch (object) {
			case Keyword(Tag(r)):
				ref = r;
				parent = r.parent() != null ? r.parent() : Keyword(Tag(dummyRef));
				if (!ignore) children = r.tokens.filter( 
					function(t:DOMNode) {
						return t.nodeType == NodeType.Element || t.nodeType == NodeType.Document;
					}
				);
				
			case _:
				parent = Keyword(Tag(dummyRef));
		}
		
		switch(token) {
			case Universal:
				condition = true;
				//results.push( object );
				
			case CssSelectors.Type(name):
				condition = ref.name == name;
				//if (ref.name == name) results.push( object );
				
			case CssSelectors.ID(name):
				condition = ref.attributes.exists('id') && ref.attributes.get('id') == name;
				/*if (ref.attributes.exists('id') && ref.attributes.get('id') == name) {
					results.push( object );
				}*/
				
			case CssSelectors.Class(names):
				condition = ref.attributes.exists('class');
				action = function() {
					var parts = ref.attributes.get('class').split(' ');
					
					for (name in names) if (parts.indexOf(name) > -1) {
						results.push( object );
						break;
					}
				}
				/*if (ref.attributes.exists('class')) {
					var parts = ref.attributes.get('class').split(' ');
					
					for (name in names) if (parts.indexOf(name) > -1) {
						results.push( object );
						break;
					}
				}*/
				
			case Group(selectors): 
				// We don't want to check children on a group of selectors.
				children = null;
				
				for (selector in selectors) {
					results = results.concat( process( object, selector, ignore, negative, parent ) );
				}
				
			case Combinator(current, next, type):
				// We will process the current `object` based on `next`,
				// the `children` will be handled inside the next `process`.
				children = null;
				
				// CSS selectors are read from `right` to `left`
				previous = current;
				var part1 = process( object, next, ignore, negative, parent );
				var part2 = [];
				
				if (part1.length > 0) {
					part2 = processCombinator(object, part1, current, type);
				}
				
				condition = true;
				action = function() results = results.concat( part2 );
				
			case Pseudo(_.toLowerCase() => name, _.toLowerCase() => expression):
				switch(name) {
					case 'root':
						if (condition = ref.parent() == null) {
							//results.push( object );
							// We have found the `root`, so ignore `children`.
							children = null;
						}
						
					case 'link':
						condition = ref.attributes.exists( 'href' );
						//if (ref.attributes.exists( 'href' )) results.push( object );
						
					case 'enabled':
						condition = ref.attributes.exists( 'enabled' );
						/*if (ref.attributes.exists( 'enabled' )) {
							results.push( object );
						}*/
						
					case 'disabled':
						condition = ref.attributes.exists( 'disabled' );
						/*if (ref.attributes.exists( 'disabled' )) {
							results.push( object );
						}*/
						
					case 'first-child':
						condition = true;
						action = function() {
							results = results.concat( nthChild( children, 0, 1 ) );
							// `children` are handled by `nthChild`.
							children = null;
						}
						
					case 'last-child':
						condition = true;
						action = function() {
							results = results.concat( nthChild( children, 0, 1, true ) );
							// `children` are handled by `nthChild`.
							children = null;
						}
						
					case 'nth-last-child':
						var values = nthExpression( expression );
						var a = values[0];
						var b = values[1];
						var n = expression.indexOf('-n') > -1;
						
						var values = nthChild( children, a, b, true, n );
						condition = true;
						action = function() results = results.concat( values );
						children = null;
						
					case 'nth-child':
						var values = nthExpression( expression );
						var a = values[0];
						var b = values[1];
						var n = expression.indexOf('-n') > -1;
						
						var values = nthChild( children, a, b, false, n );
						condition = true;
						action = function() results = results.concat( values );
						children = null;
						
					case 'only-child':
						condition = (parent:DOMNode).childNodes.length == 1;
						/*if ((parent:DOMNode).childNodes.length == 1) {
							results.push( object );
							
						}*/
						
					case 'has':
						
					case 'val':
						
					case 'empty':
						// We need the original unfiltered children.
						/*var _children = */switch (object) {
							case Keyword(Tag( { tokens:t } )): 
								//t;
								condition = t.length == 0 || t.length == t.filter( function(c) return c.match( Keyword(Instruction(_)) ) ).length;
							case _: /*[];*/
						}
						
						// Only allow `length == 0` or children which are `Instructions`
						/*if (
							_children.length == 0 || 
							_children.length == _children.filter( function(c) return c.match( Keyword(Instruction(_)) ) ).length
						) {
							results.push( object );
						}*/
						//condition = _children.length == 0 || _children.length == _children.filter( function(c) return c.match( Keyword(Instruction(_)) ) ).length;
						
					case 'not' if (expression.trim() != ''):
						var _selector = expression.parse();
						var _results = process(object, _selector, ignore, true, parent);
						var _pass = false;
						for (result in _results) _pass = result.equals( object );
						if (_pass) results.push( object );
						
					case _.endsWith('of-type') => true:
						// This section feels completely wrong,
						// going up a level, then the `nth`ing method.
						
						var copy = (parent:DOMNode).childNodes;
						var values = [];
						var a = 0;
						var b = 1;
						var n = false;
						
						if (name.indexOf('nth') > -1) {
							values = nthExpression( expression );
							a = values[0];
							b = values[1];
							n = expression.indexOf('-n') > -1;
							
						}
						
						// Filter array of elements by `previous` css token. So
						// in effect reading the css rule from left to right,
						// the wrong way in css.
						copy = nthChild( copy.filter( filterToken.bind(_, previous) ), a, b, name.indexOf('last') > -1 ? true : false, n );
						
						if (copy[0] == (object:DOMNode)) {
							if (name.indexOf('only') > -1) {
								condition = (object:DOMNode).parentNode.childNodes.length == 1;
								/*if ((object:DOMNode).parentNode.childNodes.length == 1) {
									// results.push( object );
									//condition = true;
								}*/
								
							} else {
								//results.push( object );
								condition = true;
							}
							
						}
						
					case _:
				}
				
			case Attribute(name, type, value):
				if (ref.attributes.exists( name )) {
					switch (type) {
						// Assume its just matching against an attribute name, not the value.
						case Unknown:
							condition = true;
							//results.push( object );
							
						case Exact:
							condition = ref.attributes.get(name) == value;
							/*if (ref.attributes.get(name) == value) {
								results.push( object );
							}*/
							
						case List:
							for (v in ref.attributes.get(name).split(' ')) {
								if (condition = v == value) {
									//results.push( object );
									break;
								}
							}
							
						case DashList:
							for (v in ref.attributes.get(name).split('-')) {
								if (condition = v == value) {
									//results.push( object );
									break;
								}
							}
							
						case Prefix:
							condition = ref.attributes.get(name).startsWith( value );
							/*if (ref.attributes.get(name).startsWith( value )) {
								results.push( object );
							}*/
							
						case Suffix:
							condition = ref.attributes.get(name).endsWith( value );
							/*if (ref.attributes.get(name).endsWith( value )) {
								results.push( object );
							}*/
							
						case Contains:
							condition = ref.attributes.get(name).indexOf( value ) > -1;
							/*if (ref.attributes.get(name).indexOf( value ) > -1) {
								results.push( object );
							}*/
							
						case _:
					}
					
				}
				
			case _:
				
		}
		
		if (!negative && condition) action();
		else if (negative && !condition) results.push( object );
		
		if (children != null) {
			for(child in children) results = results.concat( process( child, token, ignore, negative, parent ) );
		}
		
		ref = null;
		children = null;
		
		return results;
	}
	
	/**
	 * 
	 * @param	children	An array containing objects typed `Keyword<HtmlKeywords>`.
	 * @param	a			An `Int`.
	 * @param	b			An `Null<Int>`.
	 * @param	reverse		If `a` and/or `b` operate on a reverse array.
	 * @param	neg			If the expression was negative.
	 * @return
	 */
	private static function nthChild(children:Tokens, a:Int, b:Null<Int>, reverse:Bool = false, neg:Bool = false):Tokens {
		var n = 0;
		var results = [];
		
		if (reverse) {
			children = children.copy();
			children.reverse();
		}
		
		if (b != null) {
			var len = children.length;
			var idx = (a * (neg? -n : n)) + b - 1;
			var values = [];
			
			while ( n < len && idx < len ) {
				if (idx > -1) {
					values.push( children[idx] );
				}
				
				if (a == 0 && !neg) break;
				
				n++;
				idx = (a == 0 && neg? -n:(a * (neg? -n : n))) + b - 1;
			}
			
			if (values.length > 0) {
				if (neg) values.reverse();
				results = results.concat( values );
			}
			
		} else {
			// If argument `b` is null, `a` is the position of a single
			// element.
			results.push( children[a - 1] );
		}
		
		return results;
	}
	
	/**
	 * 
	 * @param	expr		An nth expression of `odd`, `even` or `-n+2`.
	 * @return	Array<Int>	If `length == 1` its an absolute position. If `length == 2` then pass values to `nthChild` as arguments `a` and `b`.
	 */
	private static function nthExpression(expr:String):Array<Int> {
		return switch (expr) {
			case 'odd':
				[2, 1];
				
			case 'even':
				[2, 0];
				
			case _:
				nthValues( expr );
				
		}
	}
	
	/**
	 * 
	 * @param	expr		An nth expression of `3`, `-n+2` or `2n4`.
	 * @return	Array<Int>	If `length == 1` its an absolute position. If `length == 2` then pass values to `nthChild` as arguments `a` and `b`.
	 */
	private static function nthValues(expr:String):Array<Int> {
		var results:Array<Int> = [];
		
		if (expr.indexOf('n') > -1) {
			for (s in expr.split('n')) {
				results = results.concat( nthValues( s ) );
			}
		}
		
		if (results.length < 2) {
			
			var code = 0;
			var index = 0;
			var value = '0';
			var isFalse = false;
			
			while (index < expr.length) {
				code = expr.charCodeAt( index );
				
				switch (code) {
					case '-'.code: isFalse = true;
					case '+'.code: isFalse = false;
					case x if (x >= '0'.code && x <= '9'.code):
						value += String.fromCharCode( x );
						
					case _:
				}
				
				index++;
			}
			
			results.push( isFalse ? -Std.parseInt( value ) : Std.parseInt( value ) );
			
		}
		
		return results;
	}
	
	
	private static function processCombinator(original:Token<HtmlKeywords>, objects:Tokens, current:CssSelectors, type:CombinatorType, ?parent:Token<HtmlKeywords> = null):Tokens {
		var results = [];
		
		switch (type) {
			case None:
				for (object in objects) {
					results = results.concat( process( object, current, true, parent ) );
				}
				
			case Child:
				var _filter = filterToken.bind(_, current);
				
				for (object in objects) {
					var lineage = buildLineage( object ).filter( _filter );
					
					// TODO check performance as `==` is `enum.equals(enum)` which is a deep
					// comparision test.
					for (ancestor in lineage) if ((object:DOMNode).parentNode == (ancestor:DOMNode)) {
						results.push( object );
					}
				}
				
			case Descendant:
				var _filter = filterToken.bind(_, current);
				
				for (object in objects) {
					var lineage = buildLineage( object );
					lineage = lineage.filter( _filter );
					if (lineage.length > 0) results.push( object );
				}
				
			case Adjacent:
				// It will select the `target` element that 
				// immediately follows the `former` element.
				var former:Array<DOMNode> = process( original, current, parent );
				var target:Array<DOMNode> = objects;
				
				for (f in former) {
					for (t in target) {
						var fp = f.parentNode;
						if (fp.equals(t.parentNode)) {
							var fpc = fp.childNodes;
							var index1 = fpc.indexOf( f );
							var index2 = fpc.indexOf( t );
							
							if (index1 > -1 && index2 > -1 && index2 - 1 == index1) {
								results.push( t );
							}
						}
					}
					
				}
				
			case General:
				// Match the `second` element only if it
				// is preceded by the `first` element.
				var first:Array<DOMNode> = process( original, current, parent );
				var second:Array<DOMNode> = objects;
				
				// This should probably be hand written as abstracts get inlined.
				for (f in first) {
					for (s in second) {
						var fp = f.parentNode;
						if (fp.equals(s.parentNode)) {
							var fpc = fp.childNodes;
							var index1 = fpc.indexOf( f );
							var index2 = fpc.indexOf( s );
							
							if (index1 > -1 && index2 > -1 && index2 > index1) {
								results.push( s );
							}
						}
					}
					
				}
		}
		
		return results;
	}
	
	private static function filterToken(token:Token<HtmlKeywords>, selector:CssSelectors):Bool {
		var ref = null;
		var result = false;
		
		switch (token) {
			case Keyword(Tag(r)): ref = r;
			case _:
		}
		
		if (ref != null) switch(selector) {
			case Universal: 
				result = true;
				
			case CssSelectors.Type(n): 
				result = ref.name == n;
				
			case CssSelectors.Class(ns): 
				var r = false;
				
				if (ref.attributes.exists('class')) {
					for (c in ref.attributes.get('class').split(' ')) {
						if (ns.indexOf(c) > -1) {
							r = true;
							break;
						}
					}
				}
				
				result = r;
				
			case CssSelectors.ID(n):
				result = ref.attributes.exists('id') && ref.attributes.get('id') == n;
				
			case Group(selectors):
				for (s in selectors) {
					result = filterToken(token, s);
					if (result) break;
				}
				
			case _:
				
		}
		
		return result;
	}
	
	/**
	 * 
	 * @param	token	A single Keyword<HtmlKeywords>.
	 * @return	Array<Keyword<HtmlKeywords>>	An array of parent tokens.
	 */
	private static function buildLineage(token:DOMNode):Tokens {
		var results = [];
		
		while (token.parentNode != null) {
			token = token.parentNode;
			results.push( token );
		}
		
		return results;
	}
	
}