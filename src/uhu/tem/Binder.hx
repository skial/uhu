package uhu.tem;

import dtx.DOMCollection;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.TypeTools;

import uhu.tem.Common;

using Detox;
//using uhu.tem.Util;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */

class Binder {
	
	public static var currentElement:Xml = null;
	public static var currentFields:Array<Field> = [];
	
	public static function parse(xml:Xml, fields:Array<Field>) {
		
		currentFields = fields;
		
		if (!Common.currentClass.meta.has(':TemIgnore')) {
			
			// Add public instance fields if they dont exist
			createTemInstanceFields();
			// Add public static function TemCreate to class if it doesnt exist
			createTemStaticsFields();
			
		}
		
		for (x in xml) {
			
			try {
				processXML( x );
			} catch (e:Dynamic) { }
			
		}
		
		return currentFields;
		
	}
	
	public static function processXML(xml:Xml) {
		
		var fields:Array<String>;
		var field:String;
		var pack:Array<String>;
		var name:String;
		var mfield:Field;
		
		if ( xml.exists(Common.x_instance) ) {
			
			currentElement = xml;
			fields = xml.attr(Common.x_instance).split(' ');
			
			for (field in fields) {
				
				pack = field.split('.');
				name = pack.pop();
				//var mfield = Common.currentFields.exists( name );
				mfield = currentFields.get( name );
				
				fieldKind( mfield );
			}
			
		}
		
		if ( xml.exists(Common.x_static) ) {
			
			currentElement = xml;
			field = xml.attr(Common.x_static).split(' ')[0];
			
			pack = field.split('.');
			name = pack.pop();
			//var mfield = Common.currentStatics.exists( name );
			mfield = currentFields.get( name );
			
		}
		
		for (child in xml.children()) {
			processXML( child );
		}
		
	}
	
	public static function fieldKind(field:Field) {
		var type:ComplexType = null;
		var expr:Expr = null;
		
		var get:Field = null;
		var set:Field = null;
		
		var get_expr:Expr = null;
		var set_expr:Expr = null;
		
		var helper_name:String;
		var helper_type:FieldType;
		var helper_meta:Array<MetadataEntry> = [];
		
		switch (field.kind) {
			// Turn a normal variable into a getter/setter variable.
			case FVar(t, e):
				type = t;
				expr = e;
				
				helper_name = 'TemNodeFor_' + field.name;
				field.kind = FProp('get_' + field.name, 'set_' + field.name, t, e);
				field.meta.push( createMetaEntry(':isVar', []) );
				
				get_expr = macro {
					if ($i{helper_name} != null) {
						return dtx.single.ElementManipulation.innerHTML( $i{ helper_name } );
					} else if ($i{ helper_name } == null) {
						$i { helper_name } = dtx.single.Traversing.find(classNode, '[data-${field.name}]').collection[0];
						trace($i { helper_name } );
						return dtx.single.ElementManipulation.innerHTML( $i { helper_name } );
					}
					return $i{field.name};
				}
				
				set_expr = macro {
					return v;
				};
				
				// Define helper variables type and expression.
				helper_type = FVar(
					macro : dtx.DOMNode,
					macro null
				);
				
				currentFields.push( createField(helper_name, helper_type, helper_meta, false) );
				currentFields.push( field.createGetter( get_expr ) );
				currentFields.push( field.createSetter( set_expr ) );
				
			case FProp(g, s, t, e):
				
				switch (g) {
					case 'default', 'null', 'dynamic', 'never', '':
						get = null;
					case n if (currentFields.exists( n )):
						get = currentFields.get( n );
				}
				
				switch (s) {
					case 'default', 'null', 'dynamic', 'never', '':
						set = null;
					case n if (currentFields.exists( n )):
						set = currentFields.get( n );
				}
				
				type = t;
				expr = e;
				
			case FFun(f):
				type = f.ret;
				expr = f.expr;
				
		}
		
	}
	
	public static function createTemInstanceFields():Void {
		
		if (Common.currentFields.length > 0) {
			
			if (!currentFields.exists( 'classNode' )) {
				
				var field_type:FieldType = null;
				var field_meta:Array<MetadataEntry> = null;
				
				field_type = FVar(
					macro : dtx.DOMNode,
					macro null
				);
				
				field_meta = [ createMetaEntry(':keep', []) ];
				
				currentFields.push( createField('classNode', field_type, field_meta, false) );
				
			}
			
		}
		
	}
	
	public static function createTemStaticsFields():Void {
		
		if (Common.currentFields.length > 0) {
			
			if (!currentFields.exists( 'TemCreate' )) {
				
				var class_name = Common.currentClass.name;
				var complex_type = Context.getType( Common.currentClass.name );
				var return_type = TypeTools.toComplexType( complex_type );
				
				var field_type:FieldType = null;
				var field_meta:Array<MetadataEntry> = null;
				
				// First create TemCreate(node:DOMNode) { ... }
				field_type = FFun( {
					args:[
						{
							name:'node',
							opt:false,
							type:macro :dtx.DOMNode,
						},
					],
					ret:return_type ,
					expr:macro {
						var cls = $ { Context.parse( 'new $class_name()', Context.currentPos() ) };
						cls.classNode = node;
						trace('Hello from $class_name');
						trace(node);
						return cls;
					},
					params:[]
				} );
				
				currentFields.push( createField('TemCreate', field_type, [], true) );
				
				// Then create __init__ method
				field_type = FFun( {
					args:[],
					ret:null ,
					expr:macro {
						TemHelper.runtime_classes.set( '$class_name', ${Context.parse('$class_name', Context.currentPos())} );
					},
					params:[]
				} );
				
				field_meta = [ createMetaEntry(':keep', []) ];
				
				currentFields.push( createField('__init__', field_type, field_meta, true) );
			}
			
		}
		
	}
	
	public static function createMetaEntry(name:String, params:Array<Expr>):MetadataEntry {
		var newMeta = null;
		
		if (params == null) {
			params = [];
		}
		
		newMeta = {
			name:name,
			params:params,
			pos:
			#if macro
			Context.currentPos()
			#else
			{
				file:'',
				min:0,
				max:1
			}
			#end
			,
		}
		
		return newMeta;
	}
	
	public static function createField(name:String, kind:FieldType, meta:Array<MetadataEntry>, isStatic:Bool):Field {
		var newField:Field = null;
		var newAccess = [APublic];
		
		if (isStatic) {
			newAccess.push( AStatic );
		}
		
		if (meta == null) {
			meta = [];
		}
		
		newField = {
			name:name,
			doc:null,
			access:newAccess,
			kind:kind,
			pos:
				#if macro
				Context.currentPos()
				#else
				{
					file:'',
					min:0,
					max:1
				}
				#end
				,
			meta:meta
		}
		
		return newField;
		
	}
	
}
