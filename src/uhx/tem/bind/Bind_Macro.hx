package uhu.tem.bind;

import haxe.macro.Context;
import haxe.macro.TypeTools;
import uhu.tem.Common;
import uhu.tem.i.IBind;
import uhu.tem.Validate;

import haxe.macro.Expr;

using Detox;
using StringTools;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class Bind_Macro implements IBind {
	
	public var dom:DOMNode;
	public var common:Common;
	
	public var validate:Validate;
	
	public var field_type:FieldType;
	public var field_meta:Array<MetadataEntry>;

	public function new(common:Common) {
		this.common = common;
		this.dom = common.html;
		
		validate = new Validate();
	}
	
	public function parse() {
		
		if (!common.current.cls.meta.has( ':TemIgnore' ) && common.fields.length > 0) {
			
			createHelpers();
			
			for (node in dom) {
				
				try {
					process( node );
				} catch (e:Dynamic) {
					
				}
				
			}
			
		}
		
	}
	
	public function process(node:DOMNode) {
		
		if (node.exists( common.binding )) {
			
			var fields = node.attr( common.binding ).split( ' ' );
			
			for (field in fields) {
				
				var path = field.split( '.' );
				var field_name = path.pop().trim();
				var class_name = path.pop().trim();
				
				bind( class_name, common.fields.get( field_name ) );
				
			}
			
		}
		
		for (child in node.children( true )) {
			
			process( child );
			
		}
		
	}
	
	public function bind(cname:String, field:Field) {
		
		if (!field.meta.exists(':TemDone')) {
			
			switch (field.kind) {
				case FVar(t, e):
					bindFVar(cname, field, t, e);
					
				case FProp(g, s, t, e):
					bindFProp(cname, field, g, s, t, e);
					
				case FFun(f):
					bindFFun(cname, field, f);
					
			}
			
		}
		
	}
	
	public function wrapExpression(value:TComplexString, expr:Expr, getter:Bool) {
		var result = macro null;
		
		if (getter) {
			switch (value.name) {
				case 'String':
					result = expr;
					
				case 'Int':
					result = macro Std.parseInt( $ { expr } );
					
				case 'Float':
					result = macro Std.parseFloat( $ { expr } );
					
				case _:
			}
		} else {
			switch (value.name) {
				case 'String':
					result = expr;
				case _:
					result = macro Std.string( $ { expr } );	//	Possible to find a toString?? Even though this should force a toString...
			}
		}
		
		return result;
	}
	
	public function bindFVar(cname:String, field:Field, t:ComplexType, e:Expr) {
		field.kind = FProp('get_' + field.name, 'set_' + field.name, t, e);
		field.meta.push( createMeta(':isVar', []) );
		field.meta.push( createMeta(':TemDone', []) );
		
		var node_name = 'TemNodeFor_' + field.name;
		var node_selector = macro '.$cname.UhuTem[data-binding*="$cname.${field.name}"]';
		
		var return_expr = macro dtx.single.ElementManipulation.innerHTML( $i { node_name } );
		var wrapped_expr = wrapExpression(field.toType(), return_expr, true);
		
		var getter_expr = macro {
			
			if ($i { node_name } != null) {
				
				return $wrapped_expr;
				
			} else if ($i { node_name } == null) {
				
				var nodes = dtx.single.Traversing.find( TemClassNode, '[data-binding*="$cname.${field.name}"]' );
				if (nodes.collection.length > 0) {
					
					$i { node_name } = nodes.collection[0];
					return $wrapped_expr;
					
				} else if (TemClassNode.hasAttribute( 'data-${field.name}' )) {
					
					$i { node_name } = TemClassNode;
					return $wrapped_expr;
				}
				
			}
			
			return $i { field.name };
		}
		
		wrapped_expr = wrapExpression(field.toType(), macro v, false);
		
		var setter_expr = macro {
			$i { field.name } = v;
			if ($i { node_name } != null) {
				
				dtx.single.ElementManipulation.setInnerHTML($i { node_name }, $wrapped_expr);
				
			} else if ($i { node_name } == null) {
				
				var nodes = dtx.single.Traversing.find( TemClassNode, '[data-binding*="$cname.${field.name}"]' );
				if (nodes.collection.length > 0) {
					
					$i { node_name } = nodes.collection[0];
					dtx.single.ElementManipulation.setInnerHTML( $i { node_name }, $wrapped_expr );
					
				} else if (TemClassNode.hasAttribute( 'data-${field.name}' )) {
					
					$i { node_name } = TemClassNode;
					dtx.single.ElementManipulation.setInnerHTML( $i { node_name }, $wrapped_expr );
					
				}
				
			}
			return v;
		}
		
		// Create `TemNodeFor_*` variable
		field_type = FVar(macro : dtx.DOMNode);
		field_meta = [ createMeta(':TemDone', []) ];
		common.fields.push( createField(node_name, false) );
		
		// Create getter for field
		common.fields.push( field.createGetter( getter_expr ) );
		
		// Create setter for field
		common.fields.push( field.createSetter( setter_expr ) );
	}
	
	public function bindFProp(cname:String, field:Field, g:String, s:String, t:ComplexType, e:Expr) {
		var getter = common.fields.get( g );
		var setter = common.fields.get( s );
		
		var node_name = 'TemNodeFor_' + field.name;
		var node_selector = macro '.$cname.UhuTem[data-binding*="$cname.${field.name}"]';
		
		// Create `TemNodeFor_*` variable
		field_type = FVar(macro : dtx.DOMNode);
		field_meta = [ createMeta(':TemDone', []) ];
		common.fields.push( createField(node_name, false) );
		
		switch (getter.kind) {
			case FFun(f):
				var old_expr = f.expr;
				var new_expr = macro {
					if ($i { node_name } != null) {
						
						return dtx.single.ElementManipulation.innerHTML( $i { node_name } );
						
					} else if ($i { node_name } == null) {
						
						$i { node_name } = dtx.Tools.find( $node_selector ).collection[0];
						return dtx.single.ElementManipulation.innerHTML( $i { node_name } );
						
					}
				};
				
				f.expr = new_expr.merge( old_expr );
				
			case _:
		}
		
		switch (setter.kind) {
			case FFun(f):
				var old_expr = f.expr;
				var new_expr = macro {
					if ($i { node_name } != null) {
						
						dtx.single.ElementManipulation.setInnerHTML($i { node_name }, v);
						
					} else if ($i { node_name } == null) {
						
						$i { node_name } = dtx.Tools.find( $node_selector ).collection[0];
						dtx.single.ElementManipulation.setInnerHTML($i { node_name }, v);
						
					}
				}
				
				f.expr = new_expr.merge( old_expr );
				
			case _:
		}
	}
	
	public function bindFFun(cname:String, field:Field, f:Function) {
		// check first input type and return type
	}
	
	/**
	 * Setup helper fields on the current class
	 */
	
	public function createHelpers() {
		var dtx_DOMNode = macro : dtx.DOMNode.DOMElement;
		
		if (!common.fields.exists( 'TemClassNode' )) {
			
			var class_name = common.current.name;
			field_type = FProp('get_TemClassNode', 'set_TemClassNode', dtx_DOMNode);
			field_meta = [ createMeta(':keep', []), createMeta(':isVar', []) ];
			
			var field = createField('TemClassNode', false);
			
			common.fields.push( field );
			
			// Create setter for TemClassNode
			common.fields.push( field.createGetter(macro {
				if (TemClassNode == null) {
					TemClassNode = cast dtx.Tools.find('.$class_name.UhuTem').collection[uhu.tem.TemHelper.current_index];
					trace('$class_name :: index == ' + uhu.tem.TemHelper.current_index);
				}
				return TemClassNode;
			} ) );
			
			// Create setter for TemClassNode
			common.fields.push( field.createSetter(macro {
				TemClassNode = v;
				return v;
			} ) );
			
		}
		
		if (!common.fields.exists( 'TemCreate' )) {
			
			var class_name = common.current.name;
			var class_type = TypeTools.toComplexType( Context.getType( class_name ) );
			
			field_type = FFun( {
				args:[
					/*{
						name:'node',
						opt:false,
						type:dtx_DOMNode,
					},*/
				],
				ret:class_type,
				expr:macro {
					var cls = $ { Context.parse('new $class_name()', createPosition() ) };
					//cls.TemClassNode = node;
					trace('Hello from $class_name. Created by TemHelper.hx');
					//trace(node);
					trace(cls.TemClassNode);
					return cls;
				},
				params:[],
			} );
			
			common.fields.push( createField('TemCreate', true) );
			
		}
		
		if (!common.fields.exists( '__init__' )) {
			
			var class_name = common.current.name;
			
			field_type = FFun( {
				args:[],
				ret:null,
				expr:macro {
					uhu.tem.TemHelper.classes.set('$class_name', { 
						name:$v{class_name}, 
						cls:$ { Context.parse('$class_name', createPosition()) },
						amount:$v{common.current.amount}
					} );
				},
				params:[],
			} );
			
			field_meta = [ createMeta(':keep', []) ];
			
			common.fields.push( createField('__init__', true) );
			
		} else {
			
			var class_name = common.current.name;
			var field = common.fields.get( '__init__' );
			
			switch (field.kind) {
				case FFun( method ):
					method.expr = method.expr.concat( macro {
						uhu.tem.TemHelper.runtime_classes.set('$class_name', $ { Context.parse('$class_name', createPosition()) } );
					} );
				case _:
			}
			
		}
	}
	
	public function createField(name:String, isStatic:Bool):Field {
		var newField:Field = null;
		var newAccess:Array<Access> = [APublic];
		
		if (isStatic) {
			newAccess.push( AStatic );
		}
		
		newField = {
			name:name,
			doc:null,
			access:newAccess,
			kind:field_type,
			pos:createPosition(),
			meta:field_meta
		}
		
		return newField;
	}
	
	public function createMeta(name:String, params:Array<Expr>):MetadataEntry {
		return {
			name:name,
			params:params,
			pos:createPosition()
		}
	}
	
	public function createPosition() {
		return 
		#if macro
		Context.currentPos();
		#else
		{
			file:'',
			min:0,
			max:1
		};
		#end
	}
	
}