package uhx.macro;

import haxe.ds.StringMap;
import haxe.macro.Compiler;
import haxe.macro.Printer;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using haxe.macro.TypeTools;
using haxe.macro.ExprTools;

/**
 * ...
 * @author Skial Bainn
 */
class Trait {

	private static function initialize() {
		try {
			KlasImp.initalize();
			KlasImp.DEFAULTS.set( ':use', Trait.handler );
		} catch (e:Dynamic) {
			// This assumes that `implements Klas` is not being used
			// but `@:autoBuild` or `@:build` metadata is being used 
			// with the provided `uhx.macro.Trait.build()` method.
		}
	}
	
	//public static var log:String;
	
	private static var onStatics:Bool = false;
	
	public static function build():Array<Field> {
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		//log = '';
		return handler( cls, fields );
	}
	
	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		for (field in fields ) if (field.meta != null) {
			if (field.meta.filter(function(m) return m.name == ':use').length > 0 && field.name == 'traits') {
				
				switch (field.kind) {
					case FVar(_, e):
						switch (e) {
							case macro [$a { a } ]:
								fields = fields.concat( 
									handleTraits( cls, a ) 
								);
								
								onStatics = true;
								fields = fields.concat(
									handleTraits( cls, a )
								);
								
							case _:
								
						}
						
					case _:
						trace('error');
						Context.fatalError('${field.name} cannot be a function or property.', field.pos);
				}
				
			}
			
		}
		//sys.io.File.saveContent( 'trait.macro.txt', log );
		return fields;
	}
	
	private static function handleTraits(cls:ClassType, exprs:Array<Expr>):Array<Field> {
		var results = [];
		
		for (expr in exprs) {
			
			switch (expr) {
				case macro $i{ i } if(!Context.defined( 'display' )):
					results = results.concat( 
						transformExprs( getExprs( Context.getType( i ) ) ) 
					);
					
				case macro $i{ i } :
					results = results.concat( 
						transformTypes( getTypes( Context.getType( i ) ) )
					);
					
				case _:
					
			}
			
		}
		
		return results;
	}
	
	private static function getExprs(type:Type):Map<ClassField, Expr> {
		var results = new Map();
		
		switch (type) {
			case TInst(t, _):
				var fields = onStatics ? t.get().statics.get() : t.get().fields.get();
				results = [for (field in fields) {
					field => switch (field.expr()) {
						case null:
							{ 
								expr:ECheckType(macro $v{null}, field.type.toComplexType()),
								pos:field.pos 
							}
							
						case { expr:e, pos:p, t:t } :
							switch (e) {
								case TFunction(_):
									Context.getTypedExpr( field.expr() );
									
								case _:
									{ 
										expr:ECheckType(
											Context.getTypedExpr( field.expr() ),
											t.toComplexType()
										),
										pos:field.pos 
									}
							}
							
							
					}
				}];
				
			case _:
				
		}
		
		return results;
	}
	
	private static function getTypes(type:Type):Map<ClassField, Type> {
		var results = new Map();
		
		switch (type) {
			case TInst(t, _):
				var fields = onStatics ? t.get().statics.get() : t.get().fields.get();
				results = [for (field in fields) {
					field => field.type;
				}];
				
			case _:
				
		}
		
		return results;
	}
	
	private static function transformExprs(exprs:Map<ClassField, Expr>):Array<Field> {
		var results = [];
		
		for (key in exprs.keys()) {
			var expr = exprs.get( key );
			var args = [];
			var name = key.name;
			var access = buildAccess( key );
			
			switch (expr) {
				case { expr:EFunction(_, { args:a, expr:es, ret:_, params:_ } ), pos:pos } :
					
					var field = (macro class A {
						function $name() $es;
					}).fields[0];
					
					field.pos = pos;
					field.access = access;
					results.push( field );
					
				case { expr:ECheckType(e, c), pos:pos }:
					var field = (macro class A {
						var $name:$c = $e;
					}).fields[0];
					
					field.pos = pos;
					field.access = access;
					results.push( field );
					
				case _:
					
			};
		}
		
		return results;
	}
	
	private static function transformTypes(types:Map<ClassField, Type>):Array<Field> {
		var results = [];
		
		for (key in types.keys()) {
			var type = types.get( key );
			var args = [];
			var name = key.name;
			var access = buildAccess( key );
			
			switch (type) {
				case TFun(a, r):
					var c = r.toComplexType();
					var field = (macro class A { 
						function $name():$c {
							untyped return null;
						}
					}).fields[0];
					
					field.pos = key.pos;
					field.access = access;
					results.push( field );
					
				case _:
					var c = type.toComplexType();
					var field = (macro class A {
						var $name:$c;
					}).fields[0];
					
					field.pos = key.pos;
					field.access = access;
					results.push( field );
					
			}
		}
		
		return results;
	}
	
	private static inline function buildAccess(field:ClassField):Array<Access> {
		var results = [field.isPublic ? APublic : APrivate];
		if (onStatics) results.push( AStatic );
		return results;
	}
	
}