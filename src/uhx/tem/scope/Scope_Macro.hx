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

	public function new(common:Common) {
		this.common = common;
		this.dom = common.html;
	}
	
	public function parse() {
		
		for (node in dom) {
			
			try {
				process( node, false );
			} catch (e:Dynamic) {
				
			}
			
		}
		
	}
	
	public function process(node:DOMNode, scoped:Bool) {
		
		if (node.exists( 'class' ) && node.hasClass( common.current.name ) || scoped) {
			
			if (!scoped) {
				common.current.amount++;
			}
			
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
					
					if (common.fields.exists( attr )) {
						
						var value = '';
						
						// Check if `data-binding` already exists
						if (node.exists( common.binding )) {
							value = node.attr( common.binding );
							value + ' ';
						}
						
						value += common.current.name + '.' + common.fields.get( attr ).name;
						
						node.setAttr( common.binding, value );
					}
					
				}
				
			}
			
			if (!scoped) {
				node.addClass( 'UhuTem' );
			}
			
		}
		
		scoped = node.hasClass( common.current.name );
		
		for (child in node.children()) {
			
			process( child, scoped );
			
		}
		
	}
	
}