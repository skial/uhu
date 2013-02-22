package uhu.tem;

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
		
		switch (field.kind) {
			case FVar(t, e):
				type = t;
				expr = e;
				
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
				
			case FFun(_):
				
				
		}
		
		if (get == null) {
			
			var getter = macro { return 'SKIAL!?!?!?!?!!!!!.....!'; };
			var setter = macro { return v; };
			
			field.kind = FProp('get_${field.name}', 'set_${field.name}', type, expr);
			
			currentFields.push( field.createGetter( getter ) );
			currentFields.push( field.createSetter( setter ) );
			
		}
		
	}
	
	public static function createTemInstanceFields():Void {
		
		if (Common.currentFields.length > 0) {
			
			if (!currentFields.exists( 'element' )) {
				
				var field_type:FieldType = null;
				var field_meta:Array<MetadataEntry> = null;
				
				field_type = FVar(
					macro : dtx.DOMNode,
					macro null
				);
				
				field_meta = [ createMetaEntry(':keep', []) ];
				
				currentFields.push( createField('element', field_type, field_meta, false) );
				
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
						cls.element = node;
						trace('Hello Tem from $class_name');
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
