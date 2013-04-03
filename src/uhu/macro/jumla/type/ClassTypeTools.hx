package uhu.macro.jumla.type;

import haxe.macro.ComplexTypeTools;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.TypeTools;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class ClassTypeTools {
	
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
			fields: statics.concat( fields ),
		};
	}
	
	public static function toTypeParams(params:Array<{name:String, t:Type}>):Array<TypeParam> {
		var result:Array<TypeParam> = [];
		
		for (param in params) {
			result.push( TPType( TypeTools.toComplexType( param.t ) ) );
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
	
	public static inline function toTypePath(cls:ClassType):TypePath {
		return {
			pack: cls.pack,
			name: cls.name,
			params: toTypeParams( cls.params ),
			sub: null
		};
	}
	
	public static function toTypeDefKind(cls:ClassType):TypeDefKind {
		var sup = cls.superClass != null ? toTypePath( cls.superClass.t.get() ) : null;
		var interfaces = [];
		
		for (inter in cls.interfaces) {
			interfaces.push( toTypePath( inter.t.get() ) );
		}
		
		var result:TypeDefKind = TDClass( sup, interfaces, cls.isInterface );
		
		return result;
	}
	
	public static function toTypeParamDecls(cls:ClassType):Array<TypeParamDecl> {
		var result:Array<TypeParamDecl> = [];
		
		for (param in cls.params) {
			result.push( { name:param.name, constraints:[TypeTools.toComplexType( param.t )] } );
		}
		
		return result;
	}
	
}