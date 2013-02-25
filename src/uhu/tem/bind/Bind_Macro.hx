package uhu.tem.bind;

import haxe.macro.Context;
import haxe.macro.TypeTools;
import uhu.tem.Common;
import uhu.tem.i.IBind;

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
	
	public var field_type:FieldType;
	public var field_meta:Array<MetadataEntry>;

	public function new(common:Common) {
		this.common = common;
		this.dom = common.html;
	}
	
	public function parse() {
		
		if (!common.current.cls.meta.has( ':TemIgnore' ) && common.fields.length > 0) {
			
			createHelpers();
			
		}
		
		for (node in dom) {
			
			try {
				process( node );
			} catch (e:Dynamic) {
				
			}
			
		}
		
		common.html = dom;
	}
	
	public function process(node:DOMNode) {
		
		if (node.exists( common.binding )) {
			
			var fields = node.attr( common.binding ).split( ' ' );
			
			for (field in fields) {
				
				var path = field.split( '.' );
				var field_name = path.pop().trim();
				var class_name = path.pop().trim();
				
				trace(path);
				trace(field_name);
				trace(class_name);
				
			}
			
		}
		
	}
	
	/**
	 * Setup helper fields on the current class
	 */
	
	public function createHelpers() {
		var dtx_DOMNode = macro : dtx.DOMNode;
		
		if (!common.fields.exists( 'TemClassNode' )) {
			
			field_type = FVar( dtx_DOMNode, macro null );
			field_meta = [ createMeta(':keep', []) ];
			
			common.fields.push( createField('TemClassNode', false) );
			
		}
		
		if (!common.fields.exists( 'TemCreate' )) {
			
			var class_name = common.current.name;
			var class_type = TypeTools.toComplexType( Context.getType( class_name ) );
			
			field_type = FFun( {
				args:[
					{
						name:'node',
						opt:false,
						type:dtx_DOMNode,
					},
				],
				ret:class_type,
				expr:macro {
					var cls = $ { Context.parse('new $class_name()', createPosition() ) };
					cls.TemClassNode = node;
					trace('Hellow from $class_name');
					trace(node);
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
					uhu.tem.TemHelper.runtime_classes.set('$class_name', $ { Context.parse('$class_name', createPosition()) } );
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