package uhu.lang.macro;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using tink.macro.tools.MacroTools;

/**
 * ...
 * @author Skial Bainn
 */

class ClassManager {
	
	private static var setGenerate:Bool = false;

	@:macro
	public static function build():Array<Field> {
		var fields = Context.getBuildFields();
		var cls = Context.getLocalClass();
		
		for (field in fields) {
			if (field.meta.length != 0) {
				
				for (m in field.meta) {
					if (m.name == ':discover') {
						
						if (cls != null) {
							
							var meta = cls.get().meta;
							
							if (meta.has(':discoverable')) {
								break;
							} else {
								cls.get().meta.add(':discoverable', [], cls.get().pos);
							}
							
						}
						
					}
				}
				
			}
		}
		
		if (setGenerate == false) {
			
			Context.onGenerate(ClassManager.onGenerate);
			setGenerate = true;
			
		}
		
		return fields;
	}
	
	private static function onGenerate(array:Array<Type>):Void {
		
		for (a in array) {
			
			sortType(a);
			
		}
		
	}
	
	private static function sortType(type:Type):Void {
		
		switch (type) {
			
			case TMono( t ):
				if (t != null) sortType(t.get());
				
			case TEnum( t, params ):
				readMeta(t.get());
				for (p in params) sortType(p);
				
			case TInst( t, params ):
				readMeta(t.get());
				readClass(t.get());
				for (p in params) sortType(p);
				
			case TType( t, params ):
				readMeta(t.get());
				for (p in params) sortType(p);
				
			case TFun( args, ret ):
				sortType(ret);
				
			case TAnonymous( a ):
				
				
			case TDynamic( t ):
				if (t != null) sortType(t);
				
			case TLazy( f ):
				sortType(f());
				
			default:
			
		}
		
	}
	
	private static function readMeta(m: { meta:MetaAccess } ):Void {
		
		if (m.meta.has(':discoverable')) {
			
		}
		
	}
	
	private static function readClass(cls:ClassType):Void {
		
		if (cls.constructor != null) {
			
			var con = cls.constructor.get();
			
			if (con.expr() != null) {
				var expr = Context.getTypedExpr(con.expr());
				
			}
			
		}
		
	}
	
}