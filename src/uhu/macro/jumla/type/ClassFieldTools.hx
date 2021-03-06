package uhu.macro.jumla.type;

import haxe.ds.StringMap;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Printer;
import haxe.macro.Type;
import haxe.macro.TypeTools;

#if neko
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class ClassFieldTools {
	
	private static var _cache:StringMap<String> = new StringMap<String>();
	
	/*public static function toFieldType(field:ClassField):FieldType {
		var result:FieldType = null;
		var type = Context.follow( field.type );
		var ctype = TypeTools.toComplexType( type );
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
				if (code.endsWith(';')) code = code.substr( 0, code.length - 1 );
				_cache.set( key, code );
			}
			
			try {
				expr = Context.parse( code, field.pos );
			} catch (e:Dynamic) {
				// the field is possibly part of an extern file
			}
			
		}
		
		switch( field.kind ) {
			case FVar(read, write):
				if (read == AccNormal && write == AccNormal) {
					result = FVar( ctype, expr );
				} else {
					result = FProp( read.toString(), write.toString(), ctype, expr );
				}
				
			case FMethod(_):
				
				if (expr != null) {
					switch (expr.expr) {
						case EFunction(_, f):
							result = FFun( f );
							
						case _:
							
					}
				} else {
					switch (field.type) {
						case TFun(args, ret):
							result = type.toFFun();
							
						case _:
							
					}
				}
		}
		
		return result;
	}*/
	
	/*public static function toField(field:ClassField, ?isStatic:Bool = false):Field {
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
		//trace( field.name );
		return result;
	}*/
	
	/*public static function toFields(fields:Array<ClassField>, ?isStatic:Bool = false):Array<Field> {
		var result:Array<Field> = [];
		for (field in fields) {
			result.push( field.toField( isStatic ) );
		}
		return result;
	}*/
	
}