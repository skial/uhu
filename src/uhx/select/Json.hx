package uhx.select;

import byte.ByteData;
import uhx.lexer.CssLexer;
import uhx.lexer.SelectorParser;

using Std;
using Reflect;
using uhx.select.Json;

/**
 * ...
 * @author Skial Bainn
 */
class Json {
	
	private static function parse(selector:String):CssSelectors {
		return new SelectorParser().toTokens( ByteData.ofString( selector ), 'json-selector' );
	}
	
	private static function matched(parent:Dynamic, child:Dynamic, results:Array<Dynamic>) {
		if (results.indexOf( parent ) == -1) results.push( parent );
	}
	
	private static function found(parent:Dynamic, child:Dynamic, results:Array<Dynamic>) {
		results.push( child );
	}
	
	public static function find(object:Dynamic, selector:String) {
		var selectors = selector.parse();
		var results = [];
		
		untyped console.log( object );
		untyped console.log( selector );
		untyped console.log( selector.parse() );
		
		return process( [object], selectors, found );
	}
	
	private static function process(objects:Array<Dynamic>, token:CssSelectors, method:Dynamic->Dynamic->Array<Dynamic>->Void, index:Int = 0, level:Int = -1):Array<Dynamic> {
		var results = [];
		
		for(object in objects) {
			switch(token) {
				case Universal:
					//untyped console.log( 'univeral' );
					results = results.concat( object );
					
				case CssSelectors.Type(_.toLowerCase() => name):
					//untyped console.log( 'type $name' );
					
					for (field in object.fields()) {
						var obj:Dynamic = object.field( field );
						
						switch (name) {
							case 'string' if (obj.is(String)): method(object, obj, results);
							case 'int' if (obj.is(Int)): method(object, obj, results);
							case 'float', 'number' if (obj.is(Float)): method(object, obj, results);
							case 'bool', 'boolean' if (obj.is(Bool)): method(object, obj, results);
							case 'array' if (obj.is(Array)): method(object, obj, results);
							case 'dynamic', 'object' if (obj.is(Dynamic)): method(object, obj, results);
							case 'null' if (obj.is(null)): method(object, obj, results);
							case _:
						}
						
						if (switch(level - 1) { case 0, -1:false; case _:true; }) {
							if (obj.is(Array)) {
								//untyped console.log( 'loop array' );
								results = results.concat( process( (obj:Array<Dynamic>), token, method, 0, level - 1 ) );
							} else switch(std.Type.typeof(obj)) {
								case TObject: 
									//untyped console.log( 'look in obj' );
									results = results.concat( process( [obj], token, method, 0, level - 1 ) );
								case _:
							}
						}
					}
					
				case CssSelectors.Class(names):
					//untyped console.log( 'class ${names[0]}' );
					// If more than one class exists, only the first is used.
					// `.a.b.c` makes no sense on json structures.
					for (field in object.fields()) {
						var obj:Dynamic = object.field( field );
						
						if (field == names[0]) method(object, obj, results);
						
						if (switch(level - 1) { case 0, -1:false; case _:true; }) {
							if (obj.is(Array)) {
								results = results.concat( process( (obj:Array<Dynamic>), token, method, 0, level - 1 ) );
							} else switch(std.Type.typeof(obj)) {
								case TObject: 
									results = results.concat( process( [obj], token, method, 0, level - 1 ) );
								case _:
							}
						}
					}
					
				case Group(selectors): 
					//untyped console.log( 'group' );
					var obj = [object];
					for (selector in selectors) {
						results = results.concat( process( obj, selector, found ) );
					}
					
				case Combinator(current, next, type):
					//untyped console.log( 'combinator' );
					var part1 = process( [object], current, matched );
					
					var part2 = switch (type) {
						case None:
							process( part1, next, method );
							
						case Child:
							process( part1, next, method, 0, 1 );
							
						case Descendant:
							process( part1, next, method );
							
						case Adjacent, General:
							//throw 'The adjacent operator `+` is not supported on dynamic (json) objects. Use the general `~` operator instead.';
						//case General:
							//var idx = objects.indexOf(part1[0], index);
							process( [object], next, method );
							
					}
					
					results = results.concat( part2 );
					
				case _:
					
			}
			
			if (level > 0) level--;
			
			switch(level) {
				case 0: break;
				case _:
			}
		}
		
		return results;
	}
	
}