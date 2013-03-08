package uhu.sys.idl;

import sys.FileSystem;
import sys.io.File;
import idl.EType;

using Std;
using StringTools;
using Lambda;

/**
 * ...
 * @author Skial Bainn
 */

class Parser {
	
	public static function main() {
		var p = new Parser();
		var t = p.parse(File.getContent('draft.idl'));
		var r = new Renderer();
		trace(r.render(t));
	}
	
	/**
	 * Find everything between the start of a line, until ; is found
	 * followed by line break, which is NOT preceded by (, ), or a 
	 * word character.
	 */
	private static var section:EReg = ~/^(.*?[^\(\)\w];)$/ms;
	private static var sub_section:EReg = ~/(\w.*{[\s\S]*?};|\w.*;)/;
	private static var sub_line:EReg = ~/(\w.*(?:{|;))/;
	private static var non_space:EReg = ~/([\S]*)/;
	private static var extras:EReg = ~/([\/:.\-\w]*)/;
	private static var extras_split:EReg = ~/[\s\(\),\[\]]/g;
	
	private var _content:String;
	private var _tokens:Array<EType>;
	private var _sections:Array<EType>;
	private var _typeMap:Hash<String>;
	private var _inSection:Bool = false;
	private var _inField:Bool = false;
	private var _markers:Array<{index:Int, next:EPosition}>;

	public function new() {
		_tokens = [];
		_sections = [];
		_markers = [];
		_typeMap = new Hash<String>();
		
		_typeMap.set('octet', 'Int');
		_typeMap.set('byte', 'Int');
		_typeMap.set('short', 'Int');
		_typeMap.set('int', 'Int');
		_typeMap.set('long', 'Int');
		_typeMap.set('long long', 'Float');
		_typeMap.set('unsigned byte', 'Int');
		_typeMap.set('unsigned short', 'Int');
		_typeMap.set('unsigned int', 'Int');
		_typeMap.set('unsigned long', 'Int');
		_typeMap.set('unsigned long long', 'Float');
		
		_typeMap.set('float', 'Float');
		_typeMap.set('double', 'Float');
		_typeMap.set('unrestricted float', 'Float');
		_typeMap.set('unrestricted double', 'Float');
		
		_typeMap.set('object', 'Dynamic');
		_typeMap.set('any', 'Dynamic');
		
		_typeMap.set('boolean', 'Bool');
		_typeMap.set('void', 'Void');
	}
	
	public function parse(content:String):Array<EType> {
		_content = content;
		
		while (eos() == false) {
			scan();
		}
		
		return _tokens;
	}
	
	private function eos():Bool {
		if (_content != '') return false;
		return true;
	}
	
	private function scan():Void {
		if (!section.match(_content)) {
			_content = '';
			return;
		}
		
		if (!sub_section.match(section.matched(0))) {
			return;
		}
		
		var def = sub_section.matched(0).trim();
		var before = (section.matched(0) == def) ? '' : section.matched(0).replace(def, '').trim();
		
		if (before != '') {
			
			var parts = extras_split.split(before);
			for (part in parts) {
				if (part.startsWith('//')) {
					_tokens.push(Comment(part));
				} else if (part.trim() != '') {
					_tokens.push(Unknown(part));
				}
			}
			
		}
		
		while (def != '') {
			
			if (!sub_line.match(def)) {
				break;
			} else {
				
				var line = sub_line.matched(0);
				var parts = line.split(' ');
				var right = sub_line.matchedRight().trim();
				
				if (right.startsWith('};')) {
					parts.push('};');
				}
				
				var i = 0;
				var copy = parts.copy();
				while (i < parts.length) {
					
					var part = parts[i].trim();
					var bits = [];
					var index = copy.indexOf(part);
					var insert = [];
					var part1 = copy.slice(0, index);
					var part2 = copy.slice(index+1);
					
					if (part.indexOf('(') != -1) {
						bits = part.split('(');
						insert = insert.concat([bits[0], '(', bits[1]]);
					}
					
					if (part.indexOf(');') != -1) {
						bits = part.split(');');
						insert = insert.concat([bits[0], ');', bits[1]]);
					}
					
					if (insert.length != 0) {
						copy = part1.concat(insert).concat(part2);
					}
					
					i++;
				}
				
				parts = copy;
				var next:EType = null;
				
				for (part in parts) {
					part = part.trim();
					
					if (part == '') continue;
					if (part.endsWith('?')) part = part.replace('?', '');
					
					if (next == null) {
					
						switch (part) {
							case 'attribute', 'readonly':
								// do nothing for now
							case 'interface', 'dictionary':
								_tokens.push(Access(Cls));
							case 'partial':
								_tokens.push(Access(Interface));
							case ':':
								if (!_inSection) {
									_tokens.push(Access(Extends));
									//next = Name('');
								} else {
									next = TypeParam('');
								}
							case '{', '(':
								
								if (!_inSection) {
									_inSection = true;
								} else if (_inSection) {
									_inField = true;
								}
								
								var block:Array<EType> = [];
								var markers:Array<{index:Int, next:EPosition}> = [];
								
								_tokens.push(Section(block, markers));
								_sections.push(Section(_tokens, _markers));
								
								_tokens = block;
								_markers = markers;
							case '};', ');':
								switch (_sections.pop()) {
									case Section(_t, _m):
										
										processMarkers();
										
										if (_inField && _tokens.length != 0) {
											var reorder:Array<EType> = [];
											var copy = _tokens.copy();
											
											reorder.push(_tokens[1]);
											reorder.push(_tokens[0]);
											
											for (i in 0..._tokens.length) {
												
												if (i != 0 && i % 2 == 0) {
													
													reorder.push(_tokens[i]);
													reorder.push(_tokens[i - 1]);
													
													copy[i] = null;
													copy[i - 1] = null;
													
												}
												
											}
											
											_t[_t.length - 1] = Section(reorder, []);
										}
										
										_tokens = _t;
										_markers = _m;
										
										/**
										 * This is all based on the assumtion that _tokens
										 * is [..., TypeParam(value), Name(value), Section(value)]
										 * and that a TypeParam is at that position...
										 */
										var re = _tokens[_tokens.length - 3];
										if (Type.enumConstructor(re) == 'TypeParam') {
											_tokens[_tokens.length - 3] = Unknown('');
											_tokens.push(re);
										}
									default:
										throw 'Problem with last section.';
								}
								
								if (!_inSection) {
									_inSection = false;
								} else if (_inSection) {
									_inField = false;
								}
							case 'long', 'void', 'double', 'float', 'octet', 'byte', 'short', 'object', 'boolean':
								_tokens.push(TypeParam(get(part)));
							default:
								if (part.endsWith(');')) part = part.replace(');', '');
								if (part.endsWith(';')) part = part.replace(';', '');
								
								if (get(part) != null) {
									part = get(part);
								}
								
								_tokens.push(Name(part));
						}
						
					} else {
						switch (next) {
							case Unknown(_):
								_tokens.push(Unknown(part));
							case Comment(_):
								_tokens.push(Comment(part));
							case TypeParam(_):
								_tokens.push(TypeParam(part));
							case Name(_):
								_tokens.push(Name(part));
							case Access(_):
								
							case Meta(_):
								
							case Section(_):
								
							default:
						}
						addSwitch(Prev);
						next = null;
					}
					
				}
				
				def = sub_line.matchedRight();
				
			}
			
		}
		
		_content = section.matchedRight();
		
	}
	
	private inline function get(value:String):Null<String> {
		return _typeMap.get(value.toLowerCase());
	}
	
	private inline function set(key:String, value:String):Void {
		_typeMap.set(key, value);
	}
	
	private inline function addSwitch(position:EPosition):Void {
		_markers.push( { index:_tokens.length - 1, next:position } );
	}
	
	private function processMarkers():Void {
		if (_markers.length != 0) {
			for (marker in _markers) {
				var i = marker.index;
				
				switch(marker.next) {
					case Next:
						i + 1;
					case Prev:
						i - 1;
					case End:
						i = _tokens.length - 1;
					case To(value):
						i = value;
					default:
				}
				
				var t1 = _tokens[marker.index];
				var t2 = _tokens[i];
				
				_tokens[marker.index] = t2;
					_tokens[i] = t1;
				}
				
			_markers = [];
		}
	}
	
}