package uhu.tem.scope;

import uhu.tem.Common;
import uhu.tem.i.IScope;

using Detox;
using Lambda;
using StringTools;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */

class Scope_Macro implements IScope {
	
	public var dom:DOMNode;
	public var common:Common;

	public function new(xml:DOMNode, common:Common) {
		this.dom = xml;
		this.common = common;
	}
	
	public function parse():DOMNode {
		
		for (node in dom) {
			
			process( node );
			
		}
		
		return dom;
		
	}
	
	public function process(node:DOMNode) {
		
		if (node.hasClass( common.current.name )) {
			
			if (common.fields.length > 0) {
				
				for (attribute in node.attributes()) {
					
					var attr = attribute;
					
					// Check if the attribute should be ignored
					if (common.ignore.indexOf( attr ) != -1) {
						continue;
					}
					
					// Remove `data-` from any attribute
					if (attribute.startsWith( 'data-' )) {
						attr = attribute.substr( 5 ).trim();
					}
					
					if (common.fields.exists( attr ) {
						
						var value = '';
						
						// Check if `data-binding` already exists
						if (node.exists( common.binding )) {
							value = node.attr( common.binding );
						}
						
						value += ' ' + common.fields.get( attr ).name;
						
					}
					
				}
				
			}
			
			node.addClass( 'UhuTem' );
			
		}
		
		for (child in node.children()) {
			
			process( child );
			
		}
		
	}
	
}