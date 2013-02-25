package uhu.tem.validate;

import uhu.macro.jumla.t.TComplexString;
import uhu.tem.i.IValidate;

import haxe.macro.Expr;

using Detox;

/**
 * ...
 * @author Skial Bainn
 */
class Validate_Macro implements IValidate {
	
	public var node:DOMNode;

	public function new() {
		
	}
	
	public function checkType(complex_str:TComplexString, field:Field, ?inLoop:Bool = false) {
		var result = false;
		
		if (complex_str != null) {
			
			switch (complex_str.name) {
				case 'String' | 'Dynamic': 
					result = checkString( complex_str, field, inLoop );
					
				case 'Float' | 'Int':
					result = checkNumber( complex_str, field, inLoop );
					
				case 'Bool':
					result = checkBool( complex_str, field, inLoop );
					
				case 'Array' | 'List':
					result = checkArray( complex_str, field, inLoop );
					
				case 'DOMNode' | 'Dom' | 'Xml':
					
					// hmm, dont think i need to check anything...
					result = true;
					
				case _:
					
					throw 'Type "${complex_str}" is currently not supported.';
			}
			
		}
		
		return result;
	}
	
	public function checkString(complex_str:TComplexString, field:Field, inLoop:Bool):Bool {
		
		var match = getAttribute(complex_str, field);
		
		if (!inLoop && match == null) {
			throw 'Can not find attribute "data-${field.name}" or "${field.name}" on $node. Check the field name is spelt correctly and the case matches.';
		}
		
		// Get all child elements, thats dom nodes, text nodes and comments.
		var children = node.children(false);
		
		if (children.length == 0) {
			throw 'The current element does not have any child nodes : $node';
		}
		
		return true;
	}
	
	public function checkNumber(complex_str:TComplexString, field:Field, inLoop:Bool):Bool {
		var match = getAttribute(complex_str, field);
		
		if (!inLoop && match == null) {
			throw 'Can not find attribute "data-${field.name}" or "${field.name}" on $node. Check the field name is spelt correctly and the case matches.';
		}
		
		var children = node.children(false);
		var valid = new DOMCollection();
		
		if (children.length == 0) {
			throw 'The current element does not have any child nodes : $node';
		}
		
		for (c in children) {
			if (c.isTextNode()) {
				valid.add(c);
			}
		}
		
		if (valid.length == 0) {
			throw 'No text nodes exist.';
		}
		
		var func = complex_str.name == 'Float' ? Std.parseFloat : Std.parseInt;
		
		try {
			var value = func( valid.first().val() );
		} catch (e:Dynamic) {
			throw '${valid.first().val()} can not be cast to Float';
		}
		return true;
	}
	
	public function checkBool(complex_str:TComplexString, field:Field, inLoop:Bool):Bool {
		// Based on HTML5 spec - This gives quick overview http://stackoverflow.com/a/4140263
		var match = getAttribute(complex_str, field);
		
		if (!inLoop && match == null) {
			throw 'Can not find attribute "data-${field.name}" or "${field.name}" on $node. Check the field name is spelt correctly and the case matches.';
		}
		
		var attr = node.attr( match );
		var spec = ( attr == '' || attr.toLowerCase() == match.toLowerCase() );
		
		if ( !spec ) {
			throw 'Attribute "$match" matched with "${field.name}" of type "Bool" has a value of "$attr". Check http://stackoverflow.com/a/4140263 for valid HTML5 booleans.';
		}
		
		return true;
	}
	
	public function checkArray(complex_str:TComplexString, field:Field, inLoop:Bool):Bool {
		/*trace(complex_str);
		trace(field);
		trace(node);*/
		var match = getAttribute(complex_str, field);
		
		if (!inLoop && match == null) {
			throw 'Can not find attribute "data-${field.name}" or "${field.name}" on $node. \nCheck the field name is spelt correctly and the case matches.';
		}
		
		if (complex_str == null) {	// fix
			throw 'No type was detected for field "${field.name}" of type "Array<Unknown>"';
		}
		
		switch (complex_str.name) {	// fix
			case 'Hash', 'Class', 'Enum':
				throw 'Type "${complex_str.name}" for "${field.name}" is not compatiable. Check the supported types again.';
		}
		
		var children = node.children(true);
		
		if (children.length == 0) {
			throw 'The current element does not have any child nodes : $node';
		}
		
		var valid = new DOMCollection();
		var originalElement = node;
		
		complex_str = complex_str.params[0];	// fix
		
		for (c in children) {
			
			node = c;
			
			checkType( complex_str, field, true );
			
		}
		
		node = originalElement;
		
		return true;
	}
	
	
	public function getAttribute(complex_str:TComplexString, field:Field):String {
		var match = null;
		
		for (a in node.attributes()) {
			
			if (a == 'data-${field.name}' || a == field.name) {
				match = a;
				break;
			}
			
		}
		
		return match;
	}
	
}