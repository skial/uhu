package uhu.mu;

using Std;
using Reflect;
using StringTools;
import haxe.ds.StringMap;
import uhu.js.Console;
import uhu.mu.t.TParser;
import uhu.mu.t.TPartial;
import uhu.mu.t.TSection;
import uhu.mu.e.ETag;
import uhu.mu.Common;
import uhu.mu.Parser;

/**
 * ...
 * @author Skial Bainn
 */
 
#if hocco
@:hocco
#end
class Renderer {
	
	private var _parser:Parser;
	
	private var _cache:StringMap<Dynamic>;
	private var _values:StringMap<Dynamic>;
	public var _partials:StringMap<String>;
	private var _sections:StringMap<Bool>;
	
	private var _state:String;
	
	private var _view:Dynamic;
	
	private var _sectionPath:Array<String>;
	
	private var _tokens:Array<ETag>;
	private var _template:String;
	private var _buffer:StringBuf;
	
	private var _sectionType:Int = null;
	
	public function new() {
		_values = new StringMap<Dynamic>();
		_cache = new StringMap<Dynamic>();
		_partials = new StringMap<String>();
		_buffer = new StringBuf();
	}
	
	public function render(parser:TParser, view:Dynamic):String {
		if (Std.is(view, StringMap)) {
			throw 'Can/t access the view. It cant/t be a Hash object. Sorry!';
		}
		
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
		
		switch (tag) {
			case Static(c):
				_buffer.add(c);
				
			case Normal(c):
				context.push(_view);
				
				if (func == null) {
					
					if (c != '.') {
						var names:Array<String> = (c.indexOf('.') == -1) ? [c] : c.split('.');
						
						result = context;
						while (names.length > 0) {
							result = _walkContext(names.shift(), result);
						}
					} else {
						result = _walkContext(c, context);
					}
					
					if (result != null) {
						result = StringTools.htmlEscape('' + result).split('"').join('&quot;');
					} else {
						result = '';
					}
					
					_buffer.add(result);
				} else {
					//_buffer.add(func(c, callback(_getField, _view)));
					_buffer.add(func(c,_getField.bind( _view )));
				}
				
			case Unescape(c):
				context.push(_view);
				if (func == null) {
					
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
					//_buffer.add(func(c, callback(_getField, _view)));
					_buffer.add(func(c, _getField.bind( _view )));
				}
				
			case Section(tag, _, tokens, template, inverted):
				
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
				
			case Comments(_):
				
			case Partials(_, psr):
				
				var parsed = psr();
				
				if (parsed != null) {
					
					for (token in parsed.tokens) {
						processETag(token, context);
					}
					
				} else {
					
					_buffer.add('');
					
				}
				
			case Delimiter(_):
				
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
		return _walkContext(path, obj);
	}
	
}