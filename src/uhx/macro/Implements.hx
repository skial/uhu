package uhx.macro;

import haxe.macro.Printer;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using uhu.macro.Jumla;
using haxe.macro.Context;
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;

/**
 * ...
 * @author Skial Bainn
 */
class Implements {
	
	public static var meta_name:String = ':implements';
	public static var cls:ClassType;
	public static var fields:Array<Field>;
	public static var blueprint:BaseType;

	public static function handler(_cls:ClassType, _fields:Array<Field>):Array<Field> {
		
		cls = _cls;
		fields = _fields;
		
		for (meta in cls.meta.get()) {
			
			if (meta.name == meta_name) {
				
				for (param in meta.params) {
					
					var name = param.toString();
					var type = Context.getType( name );
					
					handleType( type );
					
				}
				
			}
			
		}
		
		return fields;
	}
	
	private static function handleType(type:Type) {
		
		switch (type) {
			case TType(t, _):
				blueprint = t.get();
				handleType( t.get().type );
				
			case TAnonymous(a):
				var new_fields:Array<ClassField> = [];
				var new_statics:Array<ClassField> = [];
				
				for (field in a.get().fields) {
					
					if (field.meta.has(':static')) {
						new_statics.push( field );
					} else {
						new_fields.push( field );
					}
					
				}
				
				checkFields( new_fields, false );
				checkFields( new_statics, true );
				
			case TInst(t, _):
				blueprint = t.get();
				checkFields( t.get().fields.get(), false );
				checkFields( t.get().statics.get(), true );
				
			case _:
				trace( type );
		}
		
	}
	
	private static function checkFields(impls:Array<ClassField>, isStatic:Bool) {
		for (impl in impls) {
			
			if (fields.exists( impl.name )) {
				
				var field = fields.get( impl.name );
				
				switch (impl.type) {
					case TFun(args, ret):
						
						if (field.kind.getName() != 'FFun') {
							Context.error('${cls.name}::${field.name} is meant to be a function', field.pos);
						}
						
						var method:Function = field.kind.getParameters()[0];
						
						for (arg in args) {
							
							if (method.args.exists( arg.name )) {
								
								var param = method.args.get( arg.name );
								
								if (param.name != arg.name) {
									Context.error('Parameter ${param.name} should be called ${arg.name}', field.pos);
								}
								
								if (param.opt != arg.opt) {
									Context.error('Parameter ${param.name} should be optional', field.pos);
								}
								
								/*if (param.type.toType().toString() != arg.t.toString()) {
									Context.error('Parameter ${param.name} type should be ${arg.t.toString()}', field.pos);
								}*/
								
							} else {
								
								Context.error('Parameter ${arg.name} is missing from ${cls.name}::${field.name}', field.pos);
								
							}
							
						}
						
						if (method.ret != null && method.ret.toType().toString() != ret.toString()) {
							
							Context.error('${field.name} return type should be ${ret.toString()}', field.pos);
							
						}
						
					case _:
						
						
				}
				
			} else {
				
				var is_method = false;
				var output = '';
				
				switch (impl.type) {
					case TFun(args, ret):
						is_method = true;
						
						output += '${impl.name}(';
						
						output += args.map( function(arg: { t:Type, opt:Bool, name:String } ) {
							return '${arg.name}:${arg.t.toString()}';
						} ).join(', ');
						
						output += '):${ret.toString()} { ... }';
						
					case TInst(_, _) | TMono(_) | TEnum(_, _) | TType(_, _) | TAbstract(_, _):
						
						var t = impl.type.getParameters()[0];
						output += '${impl.name}:${t.get().name}';
						
					case _:
				}
				
				Context.error('${cls.name} is missing a ${isStatic?"static ":""}${is_method?"function":"var"} $output', cls.pos);
				
			}
			
		}
	}
	
}