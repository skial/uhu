package uhu.tem;

import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;

import uhu.tem.Common;

using Detox;
using uhu.tem.Util;
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
		
		// Add public instance fields if they dont exist
		createTemFields();
		// Add public static function TemCreate to class if it doesnt exist
		createTemCreate();
		
		for (x in xml) {
			
			try {
				processXML( x );
			} catch (e:Dynamic) { }
			
		}
		
		return currentFields;
		
	}
	
	public static function processXML(xml:Xml) {
		
		var fields:Array<String>;
		
		if ( xml.exists(Common.x_instance) ) {
			
			currentElement = xml;
			fields = xml.attr(Common.x_instance).split(' ');
			
			for (field in fields) {
				
				var pack:Array<String> = field.split('.');
				var name:String = pack.pop();
				var mfield = Common.currentFields.getClassField(name);
				
				
			}
			
		}
		
		if ( xml.exists(Common.x_static) ) {
			
			currentElement = xml;
			var field = xml.attr(Common.x_static).split(' ')[0];
			
			var pack:Array<String> = field.split('.');
			var name:String = pack.pop();
			var mfield = Common.currentStatics.getClassField(name);
			
			
		}
		
		for (child in xml.children()) {
			processXML( child );
		}
		
	}
	
	public static function createTemFields():Void {
		
		if (Common.currentFields.length > 0) {
			
			if (!currentFields.toTFields().hasClassField( 'element' )) {
				
				var newField:Field = {
					name:'element',
					doc:null,
					access:[APublic],
					kind:FVar(
						macro : String,
						null
					),
					pos:
						#if macro
						Context.currentPos()
						#else
						{
							file:'',
							min:0,
							max:1,
						}
						#end
						,
					meta:[
						{
							name:':keep',
							params:[],
							pos:
							#if macro
							Context.currentPos()
							#else
							{
								file:'',
								min:0,
								max:1,
							}
							#end
							,
						}
					]
				}
				
				currentFields.push( newField );
				
			}
			
		}
		
	}
	
	public static function createTemCreate():Void {
		
		if (Common.currentFields.length > 0) {
			
			if (!currentFields.toTFields().hasClassField( 'TemCreate' )) {
				
				var returnType = TypeTools.toComplexType( Context.getType( Common.currentClass.name ) );
				
				var newField:Field = { 
					name:'TemCreate',
					doc:null,
					access:[APublic, AStatic],
					kind:FFun( {
						args:[
							{
								name:'node',
								opt:false,
								type:macro :dtx.DOMNode,
							},
							{
								name:'selector',
								opt:false,
								type:macro :String,
							}
						],
						ret:returnType ,
						expr:macro {
							var cls = $ { Context.parse( 'new ${Common.currentClass.name}()', Context.currentPos() ) };
							cls.element = null;
							trace('Hello Tem from ${Common.currentClass.name}');
							return cls;
						},
						params:[]
					} ),
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
					meta:[]
				};
				
				currentFields.push( newField );
				
			}
			
		}
		
	}
	
}
