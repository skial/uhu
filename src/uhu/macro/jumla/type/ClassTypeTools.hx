package uhu.macro.jumla.type;

import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.TypeTools;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class ClassTypeTools {
	
	public static inline function path(cls:ClassType):String {
		return cls.pack.join( '.' ) + (cls.pack.length > 0 ? '.' : '') + cls.name;
	}
	
	public static function toTypeDefinition(cls:ClassType, ?prefix:String = '', ?suffix:String = ''):TypeDefinition {
		var fields = [];
		
		for (f in cls.fields.get()) {
			fields.push( f.toField() );
		}
		
		var statics = [];
		
		for (s in cls.statics.get()) {
			statics.push( s.toField( true ) );
		}
		
		return {
			pack: cls.pack,
			name: prefix + cls.name + suffix,
			pos: cls.pos,
			meta: cls.meta.get(),
			params: cls.toTypeParamDecls(),
			isExtern: cls.isExtern,
			kind: cls.toTypeDefKind(),
			fields: fields.concat( statics ),
		};
	}
	
	public static function toTypeParams(params:Array<{name:String, t:Type}>):Array<TypeParam> {
		var result:Array<TypeParam> = [];
		
		for (param in params) {
			result.push( TPType( TypeTools.toComplexType( Context.follow( param.t ) ) ) );
		}
		
		return result;
	}
	
	/*public static inline function toTypePaths(classes:Array<ClassType>):Array<TypePath> {
		var result = [];
		for (cls in classes) {
			result.push( toTypePath( cls ) );
		}
		return result;
	}*/
	
	public static function toTypePath(cls:ClassType):TypePath {
		return {
			pack: cls.pack,
			name: cls.name,
			params: toTypeParams( cls.params ),
			sub: null
		};
	}
	
	public static function toTypeDefKind(cls:ClassType):TypeDefKind {
		var sup = cls.superClass != null ? toTypePath( cls.superClass.t.get() ) : null;
		var interfaces = [for (i in cls.interfaces) i.t.get().toTypePath() ];
		return TDClass( sup, interfaces, cls.isInterface );
	}
	
	public static function toTypeParamDecls(cls:ClassType):Array<TypeParamDecl> {
		var result:Array<TypeParamDecl> = [];
		
		for (param in cls.params) {
			result.push( { name:param.name, constraints:[TypeTools.toComplexType( Context.follow( param.t ) )] } );
		}
		
		return result;
	}
	
}