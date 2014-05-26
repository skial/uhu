package uhx.select;

import byte.ByteData;
import uhx.lexer.CssLexer;
import uhx.lexer.SelectorParser;

using Std;
using Type;
using Reflect;
using uhx.select.Json;

private typedef Method = Dynamic->Dynamic->Array<Dynamic>->Void;

/**
 * ...
 * @author Skial Bainn
 */
class Json {
	
	private static function parse(selector:String):CssSelectors {
		return new SelectorParser().toTokens( ByteData.ofString( selector ), 'json-selector' );
	}
	
	private static function exact(parent:Dynamic, child:Dynamic, results:Array<Dynamic>) {
		results.push( child );
	}
	
	private static function matched(parent:Dynamic, child:Dynamic, results:Array<Dynamic>) {
		if (results.indexOf( parent ) == -1) {
			results.push( parent );
		}
	}
	
	private static function found(parent:Dynamic, child:Dynamic, results:Array<Dynamic>) {
		results.push( child );
	}
	
	private static function filter(parent:Dynamic, child:Dynamic, results:Array<Dynamic>) {
		untyped console.log( results );
	}
	
	public static function find(object:Dynamic, selector:String) {
		var selectors = selector.parse();
		var results:Array<Dynamic> = [];
		
		untyped console.log( object );
		untyped console.log( selector );
		untyped console.log( selectors );
		
		results = process( [object], selectors, found, object );
		
		// This doesnt seem right...
		if (results.length == 1 && Std.is(results[0], Array)) {
			results = results[0];
		}
		
		return results;
	}
	
	private static function process(objects:Array<Dynamic>, token:CssSelectors, method:Method, ?parent:Dynamic = null):Array<Dynamic> {
		var results = [];
		
		for (object in objects) {
			var isObject = object.typeof().match(TObject);
			
			switch(token) {
				case Universal:
					//untyped console.log( 'univeral' );
					if (object.is(Array)) results = results.concat( 
						process( object, token, method, parent )
					);
					
					if (object.typeof().match(TObject)) for (name in object.fields()) {
						var obj:Dynamic = object.field( name );
						var dyn:Dynamic = { };
						dyn.setField( name, obj );
						
						results = results.concat( 
							process( [obj], token, method, dyn )
						);
					}
					
					method( object, object, results );
					
				case CssSelectors.Type(_.toLowerCase() => name):
					//untyped console.log( 'type $name' );
					//untyped console.log( object );
					
					switch (name) {
						case 'string' if (object.is(String)):
							method( parent, object, results );
							
						case 'number', 'int' if (object.is(Int)):
							method( parent, object, results );
							
						case 'boolean', 'bool' if (object.is(Bool)):
							method( parent, object, results );
							
						case 'array' if (object.is(Array)):
							results = results.concat( 
								process( object, token, method )
							);
							
							method( parent, object, results );
							
						case 'object', 'dynamic' if (object.typeof().match(TObject)):
							for (name in object.fields()) {
								var obj:Dynamic = object.field( name );
								var dyn:Dynamic = { };
								dyn.setField( name, obj );
								
								results = results.concat( 
									process( [obj], token, method, dyn )
								);
							}
							
							method( parent, object, results );
							
						case 'null' if (object.is(null)):
							method( parent, object, results );
							
						case _ if (method != exact):
							if (object.is(Array)) results = results.concat( 
								process( object, token, method, parent )
							);
							
							if (object.typeof().match(TObject)) for (name in object.fields()) {
								//untyped console.log( 'searching object' );
								var obj:Dynamic = object.field( name );
								var dyn:Dynamic = { };
								dyn.setField( name, obj );
								
								results = results.concat( 
									process( [obj], token, method, dyn )
								);
							}
					}
					
				case CssSelectors.Class(names):
					//untyped console.log( 'class ${names[0]}' );
					// If more than one class exists, only the first is used.
					// `.a.b.c` makes no sense on json structures.
					for (name in object.fields()) {
						var obj:Dynamic = object.field( name );
						
						if (name == names[0]) {
							method( parent, obj, results);
						}
						
						if (obj.is(Array)) {
							results = results.concat( process( (obj:Array<Dynamic>), token, method, parent ) );
						}
						
						if (obj.typeof().match(TObject)) {
							results = results.concat( process( [obj], token, method, obj ) );
						}
						
					}
					
				case Group(selectors): 
					//untyped console.log( 'group' );
					var obj = [object];
					for (selector in selectors) {
						results = results.concat( process( obj, selector, found, parent ) );
					}
					
				case Combinator(current, next, type):
					//untyped console.log( 'combinator' );
					// Browser css selectors are read from `right` to `left`
					//var part1 = process( [object], current, matched );
					var part1 = process( [object], next, found, parent );
					
					if (part1.length == 0) continue;
					untyped console.log( next );
					untyped console.log( part1 );
					var part2 = switch (type) {
						case None:
							//process( part1, next, method );
							process( part1, current, exact, parent );
							
						case Child:
							//process( part1, next, method, 0, 1 );
							//process( part1, current, method, 0, 1 );
							var parents = process( [object], current, matched, parent );
							var results = [];
							
							for (parent in parents) {
								results = results.concat( childCombinator( parent, part1 ) );
								/*for (field in parent.fields()) {
									for (value in part1) {
										untyped console.log( field );
										untyped console.log( parent.field( field ) );
										untyped console.log( value );
										untyped console.log( parent.field( field ) == value );
										if (parent.field( field ) == value) {
											results.push( value );
											part1.remove( value );
											break;
										}
									}
								}*/
							}
							
							results;
							
						case Descendant:
							//process( part1, next, method );
							process( part1, current, method, parent );
							
						case Adjacent, General:
							//throw 'The adjacent operator `+` is not supported on dynamic (json) objects. Use the general `~` operator instead.';
						//case General:
							var objs = [];
							var values = [];
							var results = [];
							
							process( [object], current, function(p, c, r) {
								objs.push( p );
								values.push( c );
							}, parent );
							
							for (i in 0...objs.length) {
								var fields = Reflect.fields( objs[i] );
								
								for (j in 0...fields.length) {
									var a = Reflect.field( objs[i], fields[j] );
									var b = Reflect.field( objs[i], fields[j + 1] );
									
									if (a == values[i] && b == part1[i]) {
										results.push( part1[i] );
									}
								}
							}
							
							results;
							
					}
					untyped console.log( current );
					untyped console.log( part2 );
					results = results.concat( part2 );
					//method( parent, part2, results );
					
				case Pseudo(_.toLowerCase() => name, _.toLowerCase() => expression):
					//untyped console.log( 'pseudo $name' );
					switch(name) {
						case 'root':
							untyped console.log( parent );
							untyped console.log( object );
							var array = (object.is(Array)?object:[object]);
							for (a in array) {
								untyped console.log( a );
								method( a, a, results );
							}
							untyped console.log( results );
							
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
							var r = [];
							var e = expression.parse();
							var m = function(p, c, r) {
								r.push(p);
								
								untyped console.log(p);
								untyped console.log(c);
							};
							
							if (object.is(Array)) {
								r = r.concat( 
									process( object, e, m, parent )
								);
								
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
							}
							
						case 'val':
							
							
						case _:
					}
					
				case _:
					
			}
			
		}
		
		return results;
	}
	
	private static function nthChild(object:Dynamic, a:Int, b:Int, reverse:Bool = false, neg:Bool = false):Array<Dynamic> {
		var results = [];
		var fields = object.fields();
		
		for (i in 0...fields.length) {
			var obj:Dynamic = object.field( fields[i] );
			
			if (obj.typeof().match(TObject)) {
				var values = nthChild( obj, a, b, reverse, neg );
				results = results.concat( values );
				
			} else if (obj.is(Array)) {
				var n = 0;
				var len = (obj:Array<Dynamic>).length;
				var idx = (a * (neg? -n : n)) + b - 1;
				var values = [];
				
				if (reverse) {
					obj = (obj:Array<Dynamic>).copy();
					(obj:Array<Dynamic>).reverse();
				}
				
				while ( n < len && idx < len ) {
					if (idx > -1) {
						values.push( obj[idx] );
					}
					
					if (a == 0 && !neg) break;
					
					n++;
					idx = (a == 0 && neg? -n:(a * (neg? -n : n))) + b - 1;
				}
				
				if (values.length > 0) {
					if (neg) values.reverse();
					results = results.concat( values );
				}
				
			}
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
	
}