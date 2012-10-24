package uhu.sys.idl;

typedef StdType = Type;

import idl.EType;
import haxe.macro.Type;

using Strings;
using StringTools;
using Lambda;

using tink.macro.tools.MacroTools;

/**
 * ...
 * @author Skial Bainn
 */

typedef TClass = {
	var cls:ClassType;
	var fields:Reference<Array<ClassField>>;
	var statics:Reference<Array<ClassField>>;
}
 
class Renderer {
	
	private var _separate:Bool = false;
	private var _tokens:Array<EType>;
	private var _class_types:Hash<TClass>;
	private var _buffer:StringBuf;
	private var _previous:EType;
	private var _state:String;
	private var _indent:Int;
	private var _prev_tokens:Array<Dynamic>;

	public function new() {
		_state = '';
		_previous = null;
		_indent = 0;
		_class_types = new Hash();
		_prev_tokens = [];
	}
	
	public function render(tokens:Array<EType>, separate:Bool = false):String {
		_tokens = tokens;
		_separate = separate;
		_buffer = new StringBuf();
		
		for (token in _tokens) {
			build(token, false, '{', '}');
		}
		
		for (key in _class_types.keys()) {
			trace(key);
			trace(_class_types.get(key).fields.get());
		}
		
		return _buffer.toString();
	}
	
	private function build(type:EType, inSection:Bool, otag:String, ctag:String):Void {
		
		switch (type) {
			case Unknown(value):
				
			case Comment(text):
				
			case TypeParam(value):
				
				add(':' + value);
				
			case Name(text):
				
				add(inSection ? text.ucfirst() : text);
				
			case Access(value):
				switch (value) {
					case Cls:
						
						add('class');
						
					case Interface:
						
						add('interface');
						
					case Implements:
						
						add('implements');
						
					case Extends:
						
						add('extends');
						
					case Inline:
						
						add('inline');
						
					case Extern:
						
						add('extern');
						
					default:
				}
			case Meta(value):
				
			case Section(tokens, _):
				
				add(otag + '\n');
				inSection = true;
				
				for (token in tokens) {
					build(token, true, '', '');
				}
				
				inSection = false;
				add(ctag + '\n');
				
			default:
		}
		
		_previous = type;
		
	}
	
	private function add(value:String):Void {
		var result = value;
		
		if (_buffer.toString().endsWith('\n')) {
			result = ( _indent == 0 ? '' : '\t'.repeat(_indent) ) + result;
		}
		
		_buffer.add(result + ' ');
	}
	
	private function prevAddition():Bool {
		switch (_previous) {
			case Unknown(value):
				
			case Comment(text):
				
			case TypeParam(value):
				
			case Name(text):
				
			case Access(value):
				switch (value) {
					case Cls:
						
					case Interface:
						
					case Implements, Extends:
						return true;
					case Inline:
						
					case Extern:
						
					default:
				}
			case Meta(value):
				
			case Section(tokens):
				
			default:
		}
		
		return false;
	}
	
	private function isClassy():Bool {
		switch (_previous) {
			case Access(value):
				switch (value) {
					case Cls, Interface:
						return true;
						
					default:
				}
			default:
		}
		
		return false;
	}
	
}

class Reference<T> {
	
	var reference:T;
	
	public function new() {
		
	}
	
	public function get():T {
		return reference;
	}
	
	public function set(value:T):T {
		reference = value;
		return value;
	}
	
	public function toString():String {
		return '';
	}
}