package uhu.macro.jumla.type;

import haxe.ds.StringMap;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Printer;
import haxe.macro.Type;
import haxe.macro.TypeTools;
import sys.FileSystem;
import sys.io.File;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class ClassFieldTools {
	
	private static var _cache:StringMap<String> = new StringMap<String>();

	public static function exists(fields:Array<ClassField>, name:String):Bool {
		var result = false;
		
		for (field in fields) {
			if (field.name == name) {
				result = true;
				break;
			}
		}
		
		return result;
	}
	
	public static function get(fields:Array<ClassField>, name:String):ClassField {
		var result = null;
		
		for (field in fields) {
			if (field.name == name) {
				result = field;
				break;
			}
		}
		
		return result;
	}
	
	public static function toFieldType(field:ClassField):FieldType {
		var result:FieldType = null;
		var type = TypeTools.toComplexType( field.type );
		var expr = null;
		
		if (field.expr() != null ) {
			
			expr = Context.getTypedExpr( field.expr() ).clean();
			
		} else {
			// danger mode
			
			var pos = Context.getPosInfos( field.pos );
			var content = null;
			
			if (_cache.exists( pos.file )) {
				content = _cache.get( pos.file );
			} else {
				content = File.getContent( FileSystem.fullPath( pos.file ) );
				_cache.set( pos.file, content );
			}
			
			var code = null;
			var key = pos.file + '::' + field.name;
			
			if (_cache.exists( key )) {
				code = _cache.get( key );
			} else {
				code = content.substr( pos.min, pos.max - pos.min );
			}
			
			expr = Context.parse( code, field.pos );
			
		}
		
		switch( field.kind ) {
			case FVar(read, write):
				
				if (read == AccNormal && write == AccNormal) {
					result = FVar( type, expr );
				} else {
					result = FProp( read.toString(), write.toString(), type, expr );
				}
				
			case FMethod(_):
				
				switch (expr.expr) {
					case EFunction(_, f):
						result = FFun( f );
						
					case _:
						
				}
		}
		
		return result;
	}
	
	public static function toField(field:ClassField, ?isStatic:Bool = false):Field {
		var access = [field.isPublic ? APublic : APrivate];
		
		if (isStatic) access.push( AStatic );
		if (field.kind.getter().isInline() || field.kind.setter().isInline()) access.push( AInline );
		
		var result:Field = {
			name: field.name,
			doc: field.doc,
			access: access,
			pos: field.pos,
			kind: field.toFieldType()
		}
		
		return result;
	}
	
}