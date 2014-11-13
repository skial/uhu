package uhx.select;

import uhx.mo.Token;
import byte.ByteData;
import uhx.lexer.CssLexer;
import uhx.lexer.HtmlLexer;
import uhx.lexer.SelectorParser;
import dtx.mo.DOMNode;

using Std;
using Type;
using Reflect;
using StringTools;
using uhx.select.Html;

private typedef Tokens = Array<Token<HtmlKeywords>>;

/**
 * ...
 * @author Skial Bainn
 */
class Html {

	private static function parse(selector:String):CssSelectors {
		return new SelectorParser().toTokens( ByteData.ofString( selector ), 'html-selector' );
	}
	
	private static function exact(parent:Token<HtmlKeywords>, child:Token<HtmlKeywords>, results:Tokens) {
		results.push( child );
	}
	
	private static function matched(parent:Token<HtmlKeywords>, child:Token<HtmlKeywords>, results:Tokens) {
		if (results.indexOf( parent ) == -1) {
			results.push( parent );
		}
	}
	
	private static function found(parent:Token<HtmlKeywords>, child:Token<HtmlKeywords>, results:Tokens) {
		results.push( child );
	}
	
	private static function filter(parent:Token<HtmlKeywords>, child:Token<HtmlKeywords>, results:Tokens) {
		//untyped console.log( results );
	}
	
	public static function find(object:Tokens, selector:String) {
		var selectors = selector.parse();
		var results:Tokens = [];
		
		/*trace( object );
		trace( selector );
		trace( selectors );*/
		
		results = process( object, selectors, found );
		
		// This doesnt seem right...
		/*if (results.length == 1 && Std.is(results[0], Array)) {
			results = results[0];
		}*/
		
		return results;
	}
	
	private static function process(objects:Tokens, token:CssSelectors, method:Token<HtmlKeywords>->Token<HtmlKeywords>->Tokens->Void, ?parent:Token<HtmlKeywords> = null):Tokens {
		var results = [];
		
		//untyped console.log( objects );
		//untyped console.log( token );
		for (object in objects) {
			
			switch(token) {
				case Universal:
					//untyped console.log( 'univeral' );
					//results.push( object );
					
					var children = null;
					
					switch (object) {
						/*case Keyword(Tag(_, _, _, c, p)):
							children = c;
							parent = p();*/
							
						case Keyword(Tag(ref)):
							children = ref.tokens;
							parent = ref.parent();
							
						case _:
							
					}
					
					method(parent, object, results);
					
					if (children != null) {
						results = results.concat( process( children, token, method, parent ) );
					}
					
				case CssSelectors.Type(name):
					var children = null;
					
					switch (object) {
						/*case Keyword(Tag(n, _, _, c, p)):
							children = c;
							parent = p();
							
							//if (n == name) results.push( object );
							if (n == name) method(parent, object, results);*/
							
						case Keyword(Tag(ref)):
							children = ref.tokens;
							parent = ref.parent();
							
							//if (ref.name == name) results.push( object );
							if (ref.name == name) method(parent, object, results);
							
						case _:
							
					}
					
					if (children != null) {
						results = results.concat( process( children, token, method, parent ) );
					}
					
				case CssSelectors.ID(name):
					/*untyped console.log( 'id $name' );
					untyped console.log( object );*/
					var children = null;
					
					switch (object) {
						/*case Keyword(Tag(_, attr, _, c, p)):
							children = c;
							parent = p();
							
							if (attr.exists('id') && attr.get('id') == name) {
								//results.push( object );
								method(parent, object, results);
							}*/
							
						case Keyword(Tag(ref)):
							children = ref.tokens;
							parent = ref.parent();
							
							if (ref.attributes.exists('id') && ref.attributes.get('id') == name) {
								//results.push( object );
								method(parent, object, results);
							}
							
						case _:
							
					}
					
					if (children != null) {
						results = results.concat( process( children, token, method, parent ) );
					}
					
				case CssSelectors.Class(names):
					//untyped console.log( 'class ${names}' );
					
					var children = null;
					
					switch (object) {
						/*case Keyword(Tag(_, attr, _, c, p)):
							children = c;
							parent = p();
							
							if (attr.exists('class')) {
								var parts = attr.get('class').split(' ');
								
								for (name in names) if (parts.indexOf(name) > -1) {
									//results.push( object );
									method(parent, object, results);
									break;
								}
							}*/
							
						case Keyword(Tag(ref)):
							children = ref.tokens;
							parent = ref.parent();
							
							if (ref.attributes.exists('class')) {
								var parts = ref.attributes.get('class').split(' ');
								
								for (name in names) if (parts.indexOf(name) > -1) {
									//results.push( object );
									method(parent, object, results);
									break;
								}
							}
							
						case _:
							
					}
					
					if (children != null) {
						results = results.concat( process( children, token, method, parent ) );
					}
					
					
				case Group(selectors): 
					//untyped console.log( 'group' );
					var obj = [object];
					for (selector in selectors) {
						results = results.concat( process( obj, selector, found, parent ) );
					}
					
				case Combinator(current, next, type):
					//trace( 'combinator' );
					//trace( current, next, type );
					// Browser css selectors are read from `right` to `left`
					//var part1 = process( [object], current, matched );
					switch (object) {
						//case Keyword(Tag(_, _, _, _, p)): parent = p();
						case Keyword(Tag(ref)): parent = ref.parent();
						case _:
					}
					var part1 = process( [object], next, found, parent );
					
					if (part1.length == 0) continue;
					//untyped console.log( next );
					//untyped console.log( current );
					//untyped console.log( part1 );
					var part2 = switch (type) {
						case None:
							//process( part1, next, method );
							process( part1, current, exact, parent );
							
						case Child:
							var results = [];
							
							for (part in part1) {
								var lineage = buildLineage( part ).filter( filterToken.bind(_, current) );
								
								// TODO check performance as `==` is `enum.equals(enum)` which is a deep
								// comparision test.
								for (ancestor in lineage) if ((part:DOMNode).parentNode == (ancestor:DOMNode)) {
									results.push( part );
								}
							}
							
							results;
							
						case Descendant:
							var results = [];
							
							for (part in part1) {
								/*var ancestor = null;
								
								switch (part) {
									case Keyword(Tag(_, _, _, _, p)): ancestor = p();
									case Keyword(Ref(r)): ancestor = r.parent();
									case _:
								}*/
								
								//var ancestors = [ancestor];
								var lineage = buildLineage( part );
								
								/*while (!(ancestor:DOMNode).parentNode.equals( ancestor )) {
									ancestor = (ancestor:DOMNode).parentNode;
									ancestors.push( ancestor );
								}*/
								
								//ancestors = ancestors.filter( filterToken.bind(_, current) );
								lineage = lineage.filter( filterToken.bind(_, current) );
								//untyped console.log( ancestors );
								//untyped console.log( lineage );
								
								if (lineage.length > 0) results.push( part );
							}
							
							results;
							
						case Adjacent:
							// It will select the `target` element that 
							// immediately follows the `former` element.
							var results = [];
							var former:Array<DOMNode> = process( [object], current, method, parent );
							var target:Array<DOMNode> = part1;
							
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
							
							results;
							
						case General:
							// Match the second element only if it
							// is preceded by the first element.
							var results = [];
							var first:Array<DOMNode> = process( [object], current, method, parent );
							var second:Array<DOMNode> = part1;
							
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
							
							results;
							
					}
					//untyped console.log( current );
					//untyped console.log( part2 );
					results = results.concat( part2 );
					//method( parent, part2, results );
					
				case Pseudo(_.toLowerCase() => name, _.toLowerCase() => expression):
					//untyped console.log( 'pseudo $name' );
					switch(name) {
						case 'root':
							/*untyped console.log( parent );
							untyped console.log( object );*/
							/*var array = (object.is(Array)?object:[object]);
							for (a in array) {
								//untyped console.log( a );
								method( a, a, results );
							}*/
							//untyped console.log( results );
							
						case 'first-child':
							results = results.concat( nthChild( object, 0, 1 ) );
							
						case 'last-child':
							results = results.concat( nthChild( object, 0, 1, true ) );
							
						case 'nth-child':
							var a = 0;
							var b = 0;
							var n = false;
							
							switch (expression) {
								case 'odd':
									a = 2;
									b = 1;
									
								case 'even':
									a = 2;
									
								case _:
									var ab = nthValues( expression );
									a = ab[0];
									b = ab[1];
									n = expression.indexOf('-n') > -1;
									
							}
							
							var values = nthChild( object, a, b, false, n );
							results = results.concat( values );
							
						case 'has':
							/*var r = [];
							var e = expression.parse();
							var m = function(p, c, r) {
								r.push(p);
							};
							
							if (object.is(Array)) {
								
								if (r.length > 0) {
									results.push( parent );
								}
							}
							
							if (object.typeof().match(TObject)) for (name in object.fields()) {
								var d:Dynamic = { };
								var obj:Dynamic = object.field( name );
								Reflect.setField( d, name, obj );
								
								r = process( [obj], e, m, d );
								
								if (r.length > 0) {
									results.push( obj.typeof().match(TObject)? obj : d );
								}
							}*/
							
						case 'val':
							
						case 'first-of-type':
							switch (object) {
								case Keyword(Tag( { name:n, tokens:c } )):
									var copy = c.filter( function(t:DOMNode) return t.nodeType == NodeType.Element );
									var index = results.push( copy[0] );
									while (copy.length != 0) {
										copy = copy.filter( function(t:DOMNode) return t.nodeName != (results[index - 1]:DOMNode).nodeName );
										if (copy.length > 0) {
											index = results.push( copy[0] );
											
											switch (copy[0]) {
												case Keyword(Tag( { tokens:c } )):
													if (c.length > 0) results = results.concat( process( c, token, method, copy[0] ) );
													
												case _:
													
											}
										}
									}
									
								case _:
									
							}
							
						case _:
					}
					
				case Attribute(name, type, value):
					var attributes = null;
					var children = null;
					
					switch (object) {
						/*case Keyword(Tag(_, attr, _, c, _)):
							attributes = attr;
							children = c;*/
							
						case Keyword(Tag(r)):
							attributes = r.attributes;
							children = r.tokens;
							
						case _:
							
					}
					
					if (attributes != null && attributes.exists( name )) {
						switch (type) {
							// Assume its just matching against an attribute name, not the value.
							case Unknown:
								method(parent, object, results);
								
							//case Value(v):
								
								
							case Exact:
								if (attributes.get(name) == value) {
									method(parent, object, results);
								}
								
							case List:
								for (v in attributes.get(name).split(' ')) {
									if (v == value) {
										method(parent, object, results);
										break;
									}
								}
								
							case DashList:
								for (v in attributes.get(name).split('-')) {
									if (v == value) {
										method(parent, object, results);
										break;
									}
								}
								
							case Prefix:
								if (attributes.get(name).startsWith( value )) {
									method(parent, object, results);
								}
								
							case Suffix:
								if (attributes.get(name).endsWith( value )) {
									method(parent, object, results);
								}
								
							case Contains:
								if (attributes.get(name).indexOf( value ) > -1) {
									method(parent, object, results);
								}
								
							case _:
						}
						
					}
					
					if (children != null) {
						results = results.concat( process( children, token, method, parent ) );
					}
					
				case _:
					
			}
			
		}
		
		return results;
	}
	
	private static function nthChild(object:Token<HtmlKeywords>, a:Int, b:Int, reverse:Bool = false, neg:Bool = false):Tokens {
		var results = [];
		var children = [];
		
		switch (object) {
			/*case Keyword(Tag(_, _, _, c, _)):
				children = c;*/
				
			case Keyword(Tag(ref)):
				children = ref.tokens;
				
			case _:
				
		}
		
		var n = 0;
		var len = children.length;
		var idx = (a * (neg? -n : n)) + b - 1;
		var values = [];
		
		if (reverse) {
			children = children.copy();
			children.reverse();
		}
		
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
		
		return results;
	}
	
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
			//untyped console.log( expr, value );
			results.push( isFalse ? -Std.parseInt( value ) : Std.parseInt( value ) );
			
		}
		
		return results;
	}
	
	private static function childCombinator(object:Dynamic, values:Array<Dynamic>):Array<Dynamic> {
		var results = [];
		
		if (object.is(Array)) for (o in (object:Array<Dynamic>)) {
			results = results.concat( childCombinator( o, values ) );
		}
		
		if (object.typeof().match(TObject)) for (name in object.fields()) {
			for (v in values) if (object.field( name ) == v) {
				results.push( v );
				values.remove( v );
				break;
			}
		}
		
		return results;
	}
	
	private static function filterToken(token:Token<HtmlKeywords>, selector:CssSelectors):Bool {
		var name = null;
		var attr = null;
		var result = false;
		
		switch (token) {
			/*case Keyword(Tag(n, a, _, _, _)):
				name = n;
				attr = a;*/
				
			case Keyword(Tag(r)):
				name = r.name;
				attr = r.attributes;
				
			case _:
				
		}
		
		if (name != null && attr != null) switch(selector) {
			case Universal: 
				result = true;
				
			case CssSelectors.Type(n): 
				result = name == n;
				
			case CssSelectors.Class(ns): 
				var r = false;
				
				if (attr.exists('class')) {
					for (c in attr.get('class').split(' ')) {
						if (ns.indexOf(c) > -1) {
							r = true;
							break;
						}
					}
				}
				
				result = r;
				
			case CssSelectors.ID(n):
				result = attr.exists('id') && attr.get('id') == n;
				
			case Group(selectors):
				for (s in selectors) result = filterToken(token, s);
				
			case _:
				
		}
		
		return result;
	}
	
	private static function buildLineage(token:DOMNode):Tokens {
		var results = [];
		
		while (token.parentNode != null) {
			token = token.parentNode;
			results.push( token );
		}
		
		return results;
	}
	
}