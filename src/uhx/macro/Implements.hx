package uhx.macro;

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

	public static function handler(_cls:ClassType, _fields:Array<Field>):Array<Field> {
		
		cls = _cls;
		fields = _fields;
		
		for (meta in cls.meta.get()) {
			
			if (meta.name == meta_name) {
				
				var name = meta.params[0].toString();
				var type = Context.getType( name );
				
				handleType( type );
				
			}
			
		}
		
		return fields;
	}
	
	private static function handleType(type:Type) {
		
		trace( type );
		
		switch (type) {
			case TType(t, _):
				handleType( t.get().type );
				
			case TAnonymous(a):
				checkFields( a.get().fields );
				
			case _:
				
		}
		
	}
	
	private static function checkFields(impls:Array<ClassField>) {
		for (impl in impls) {
			
			if (fields.exists( impl.name )) {
				
				var field = fields.get( impl.name );
				var field_type = null;
				
				var impl_type = impl.type;
				
				switch ([impl.kind.getName(), field.kind.getName()]) {
					case ['FVar', 'FVar'] | ['FVar', 'FProp']:
						
						switch(field.kind) {
							case FVar(t, _) | FProp(_, _, t, _):
								field_type = t.toType();
								
							case _:
						}
						
					case _:
						
				}
				
				if (impl_type != null && field_type != null) {
					
					if (field_type.toString() != impl_type.toString()) {
						trace('MISMATCH!');
						trace(impl_type);
						trace(field_type);
					}
					
				}
			} else {
				
				Context.error('${cls.name} is missing field ${impl.name}', cls.pos);
				
			}
			
		}
	}
	
}