package uhu.mu;

using Std;
using Reflect;
using StringTools;
import uhu.js.Console;
import uhu.mu.typedefs.TParser;
import uhu.mu.typedefs.TPartial;
import uhu.mu.typedefs.TSection;
import uhu.mu.ETag;
import uhu.mu.Common;
import uhu.mu.Parser;

/**
 * ...
 * @author Skial Bainn
 */
 
class Renderer {
	
	private var _parser:Parser;
	
	private var _cache:Hash<Dynamic>;
	private var _values:Hash<Dynamic>;
	public var _partials:Hash<String>;
	private var _sections:Hash<Bool>;
	
	private var _state:String;
	
	private var _view:Dynamic;
	
	private var _sectionPath:Array<String>;
	
	private var _tokens:Array<ETag>;
	private var _template:String;
	private var _buffer:StringBuf;
	
	private var _sectionType:Int = null;
	
	public function new() {
		_values = new Hash<Dynamic>();
		_cache = new Hash<Dynamic>();
		_partials = new Hash<String>();
		//_sections = new Hash<Bool>();
		_buffer = new StringBuf();
	}
	
	public function render(parser:TParser, view:Dynamic):String {
		if (Std.is(view, Hash)) {
			throw 'Can/t access the view. It cant/t be a Hash object. Sorry!';
		}
		//trace(parser.tokens);
		_view = view;
		_tokens = parser.tokens;
		_template = parser.template;
		
		for (token in _tokens)
			processETag(token);
		
		return _buffer.toString();
	}
	
	private function processETag(tag:ETag, context:Array<Dynamic> = null, func:Dynamic = null):Void {
		var result:Dynamic = null;
		
		if (context == null) context = [_view];
		//trace(context);
		//trace(tag);
		switch (tag) {
			case Static(c):
				//trace(c.replace(' ', '_s_'));
				_buffer.add(c);
				
			case Normal(c):
				context.push(_view);
				//trace(c);
				//trace(context);
				if (func == null) {
					//result = _getField(context, c);
					
					if (c != '.') {
						var names:Array<String> = (c.indexOf('.') == -1) ? [c] : c.split('.');
						
						result = context;
						while (names.length > 0) {
							result = _walkContext(names.shift(), result);
						}
					} else {
						result = _walkContext(c, context);
					}
					
					//trace(result);
					
					if (result != null) {
						result = StringTools.htmlEscape('' + result).split('"').join('&quot;');
					} else {
						result = '';
					}
					
					_buffer.add(result);
				} else {
					_buffer.add(func(c, callback(_getField, _view)));
				}
				
			//case Unescape(c, ot, ct):
			case Unescape(c):
				context.push(_view);
				if (func == null) {
					//result = _getField(context, c);
					
					if (c != '.') {
						var names:Array<String> = (c.indexOf('.') == -1) ? [c] : c.split('.');
						
						result = context;
						while (names.length > 0) {
							result = _walkContext(names.shift(), result);
						}
					} else {
						result = _walkContext(c, context);
					}
					
					if (result == null) {
						result = '';
					}
					
					_buffer.add(result);
				} else {
					_buffer.add(func(c, callback(_getField, _view)));
				}
				
			//case Section(tag, otag, optional, ctag, tokens, template, inverted):
			case Section(tag, opening, tokens, template, inverted):
				
				var names:Array<String> = (tag.indexOf('.') == -1) ? [tag] : tag.split('.');
				
				if (_sectionType == Common.SECTION_OBJECT) {
					context.push(_view);
				}
				
				result = context;
				while (names.length > 0) {
					result = _walkContext(names.shift(), result);
				}
				
				if (_sectionType == Common.SECTION_OBJECT) {
					context = Arrays.delete(context, _view);
				}
				
				var isArray:Bool = result.is(Array);
				var isBool:Bool = result.is(Bool);
				var isObject:Bool = result.isObject();
				var isFunction:Bool = result.isFunction();
				
				if (!inverted) {
					
					if (!isFunction) {
						
						if ( result == null || (isArray && result.length == 0) || (isBool && result == false) ) {
							return;
						}
						
						var array:Array<Dynamic> = [];
						
						if (isArray) {
							
							array = result;
							_sectionType = Common.SECTION_ARRAY;
							
						} else if (isObject) {
							
							array = [result];
							_sectionType = Common.SECTION_OBJECT;
							
						} else if (isBool && result == true) {
							
							array = context;
							_sectionType = Common.SECTION_BOOLEAN;
							
						}
						
						if ( array.length != 0 ) {
							
							for (object in array) {
								for (token in tokens) {
									processETag(token, [object]);
								}
							}
							
						}
						
					} else {
						// needs to be arity 1, install of arity 2 - match specs
						var arity:String = StringTools.trim('' + result);
						
						if (arity == '#function:0') {
							context.setField(tag, context.callMethod(result, []) );
							
							for (token in tokens) {
								processETag(token, context);
							}
						}
						
						if (arity == '#function:2') {
							_buffer.add(result(template, _render));
						}
						
					}
					
				} else {
					
					if ( (isArray && result.length != 0) || (isBool && result == true) || (isObject && !isArray) ) {
						return;
					}
					
					for (token in tokens) {
						processETag(token, [_view]);
					}
					
				}
				
			//case Comments(c, ot, ct):
			case Comments(c):
				
			//case Partials(c, ot, ct, psr):
			case Partials(c, psr):
				
				var parsed = psr();
				
				if (parsed != null) {
					
					for (token in parsed.tokens) {
						processETag(token, context);
					}
					
				} else {
					
					_buffer.add('');
					
				}
				
			//case Delimiter(c, ot, ct):
			case Delimiter(c):
				
			default:
				trace('renderer: default');
		}
	}
	
	// Internal
	
	public function _walkContext(name:String, stack:Array<Dynamic>):Null<Dynamic> {
		var result = null;
		
		if (name == '.') return stack[0];
		if (!Std.is(stack, Array)) stack = [stack];
		
		//if (!_cache.exists(name)) {
			
			for (context in stack) {
				
				var isArray:Bool = Std.is(context, Array);
				var isObject:Bool = Reflect.isObject(context);
				
				if (isObject && !isArray) {
					
					result = Objects.field(context, name, null);
					
					if (result == null) {
						
						for (id in Reflect.fields(context)) {
							
							var object = Reflect.field(context, id);
							
							if (id == name) {
								
								result = object;
								_setCacheItem(name, result, context);
								break;
								
							} else {
								
								result = _walkContext(name, [object]);
								_setCacheItem(name, result, context);
								
								(result != null) ? break : continue;
							}
							
						}
						
					} else {
						_setCacheItem(name, result, context);
					}
					
				} else if (isArray) {
					result = _walkContext(name, context);
				}
				
				result != null ? break : continue;
				
			}
			
		/*} else {
			result = _cache.get(name);
		}*/
		
		return result;
	}
	
	private inline function _setCacheItem(name:String, value:Dynamic, context:Dynamic):Void {
		if (_view == context) {
			_cache.set(name, value);
		}
	}
	
	private function _render(template:String):String {
		var parser = new Parser();
		var parsed = parser.parse(template);
		var oldBuf = _buffer;
		
		_buffer = new StringBuf();
		
		for (token in parsed.tokens) {
			processETag(token, [_view]);
		}
		
		var result = _buffer.toString();
		
		_buffer = oldBuf;
		
		return result;
	}
	
	private function _getField(obj:Dynamic, path:String):Dynamic {
		/*var parts:Array<String> = [];
		var context:Dynamic = obj;
		
		if (path.indexOf('.') != -1) {
			parts = path.split('.');
		}
		
		if (parts.length == 0) {
			context = Reflect.field(obj, path);
		} else {
			
			for (part in parts) {
				
				context = Reflect.field(context, part);
				
			}
			
		}
		
		return context;*/
		return _walkContext(path, obj);
	}
	
	private function _sectionFalseOrEmpty(object:Dynamic, isArray:Bool, isBool:Bool):Bool {
		if (object == null)
			return true;
		
		if (isArray && cast (object, Array<Dynamic>).length == 0)
			return true;
		
		if (isBool && object == false)
			return true;
			
		return false;
	}
	
	private function _sectionNonEmptyArray(array:Array<Dynamic>, tokens:Array<ETag>):Void {
		for (object in array) {
			for (token in tokens) {
				processETag(token, [object, _view]);
			}
		}
	}
	
	private function _sectionLambdas(method:Dynamic, name:String, context:Dynamic, tokens:Array<ETag>, template:String):Void {
		var arity:String = StringTools.trim('' + Reflect.field(context, name));
		
		if (arity == '#function:0') {
			context.setField(name, context.callMethod(method, []) );
			
			for (t in tokens) {
				processETag(t, [context]);
			}
		}
		
		if (arity == '#function:2') {
			_buffer.add(method(template, _render));
		}
		
	}
	
	private function _sectionNonFalseValues(tokens:Array<ETag>, ?object:Dynamic):Void {
		if (object == null) object = {};
		
		for (t in tokens) {
			processETag(t, [object, _view]);
		}
	}
	
	private function _sectionInverted(object:Dynamic, isArray:Bool, isBool:Bool):Bool {
		if (isArray && cast(object, Array<Dynamic>).length != 0)
			return true;
		
		if (isBool && object == true)
			return true;
		
		return false;
	}
	
}