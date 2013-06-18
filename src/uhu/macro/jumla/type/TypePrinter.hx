package uhu.macro.jumla.type;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import uhu.macro.jumla.expr.ExprPrinter;

using Lambda;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class TypePrinter {

	public static function printType(type:Type):String {
		var result = '';
		
		switch (type) {
			case TMono(t):
				
				if (t.get() != null) result = t.get().printType();
				
			case TEnum(t, p):
				
				result = t.get().printTEnum( p );
				
			case TInst(t, p):
				
				result = t.get().printTInt( p );
				
			case TType(t, p):
				
			case TFun(a, r):
				
			case TAnonymous(a):
				
			case TDynamic(t):
				
				if (t != null) result = t.printType();
				
			case TLazy(f):
				
				result = f().printType();
				
			case TAbstract(t, p):
				
				
		}
		
		return result;
	}
	
	public static function printMetaAccess(m:MetaAccess):String {
		var result = '';
		
		for (meta in m.get()) {
			
			result += '@${meta.name}';
			
			if (meta.params.length > 0) {
				
				result += '(';
				result += meta.params.printExprs(', ');
				result += ') ';
				
			} else {
				result += ' ';
			}
			
		}
		
		return result;
	}
	
	public static inline function printMetadata(b:BaseType):String {
		return b.meta.printMetaAccess();
	}
	
	public static function printParams(params:Array<{name:String, t:Type}>):String {
		var result = '';
		
		if (params.length > 0) {
			
			result += '<';
			result += [for (p in params) {
				var tname = p.t.getName().split('.').pop();
				var res = p.name;
				if (tname != null && tname != p.name && tname != '') {
					res += ':$tname';
				}
				res;
			}].join(', ');
			result += '> ';
		}
		
		return result;
	}
	
	public static inline function printTypeParams(b:BaseType):String {
		return b.params.printParams();
	}
	
	public static function printEnumField(f:EnumField):String {
		var result = '';
		
		result += f.meta.printMetaAccess();
		result += f.name;
		result += f.params.printParams();
		
		if (f.params.length > 0) result = result.substr(0, -1);
		
		switch (f.type) {
			case TFun(args, ret):
				result += '(';
				result += [for (a in args) (a.opt ? '?' : '') + a.name + ':' + a.t.getName().split('.').pop()].join(', ');
				result += ')';
				
			case _:
		}
		
		result += ';';
		
		return result;
	}
	
	public static function printEnumFields(e:EnumType):String {
		var result = '';
		
		var values = [
			for (key in e.names) {
				e.constructs.get( key ).printEnumField();
			}
		];
		
		result += values.join('\n\t');
		
		return result;
	}
	
	public static function printTEnum(e:EnumType, p:Array<Type>):String {
		var result = '';
		
		result += e.printMetadata();
		result += e.isPrivate ? 'private ' : '';
		result += e.isExtern ? 'extern ' : '';
		
		result += 'enum ${e.name}';
		result += e.printTypeParams();
		
		result += '{\n\t';
		result += e.printEnumFields();
		result += '\n}';
		
		return result;
	}
	
	public static function printVarAccess(v:VarAccess, read:Bool = false):String {
		var result = '';
		
		switch (v) {
			case AccNo:
				result = 'null';
				
			case AccNever:
				result = 'never';
				
			case AccResolve:
				result = 'dynamic';
				
			case AccCall:
				result = read?'get':'set';
			case AccInline:
				
			case AccRequire(r, msg):
				trace( r );
				trace( msg );
				
			case _:
		}
		
		return result;
	}
	
	public static function printMethodKind(k:MethodKind):String {
		var result = '';
		
		switch (k) {
			case MethInline:
				result = 'inline';
				
			case MethDynamic:
				result = 'dynamic';
				
			case MethMacro:
				result = 'macro';
				
			case _:
		}
		
		return result;
	}
	
	public static function printClassField(f:ClassField, ?isStatic:Bool = false):String {
		var result = '';
		trace(Context.getTypedExpr( f.expr() ).printExpr());
		result += f.isPublic ? 'public ' : 'private ';
		result += isStatic ? 'static ' : '';
		result += f.type.getName() == 'TFun' ? 'function' : 'var';
		
		switch (f.kind) {
			case FMethod(k):
				result += ' ' + k.printMethodKind();
				
			case _:
		}
		
		result += ' ${f.name}';
		
		switch (f.kind) {
			case FVar(r, w):
				if (r != AccNormal && w != AccNormal) {
					result += '(' + r.printVarAccess(true) + ', ' + w.printVarAccess() + ')';
				}
				
			case _:
		}
		
		switch (f.type) {
			case TFun(args, ret):
				result += f.params.printParams();
				result += '(';
				result += [for (a in args) (a.opt ? '?' : '') + a.name + ':' + a.t.getName().split('.').pop()].join(', ');
				result += ')';
				
				if (ret != null) {
					result += ':' + ret.getName().split('.').pop();
				}
				
			case TInst(t, p):
				result += ':' + t.get().name;
				
			case TAbstract(t, p):
				result += ':' + t.get().name;
				if (p.length > 0) {
					result += '<';
					result += [for (p in p) p.getName().split('.').pop()].join(', ');
					result += '>';
				}
				
			case _:
				trace( f.type );
		}
		
		return result;
	}
	
	public static function printClassFields(fs:Array<ClassField>, ?isStatic:Bool = false):String {
		var result = '';
		
		var values = [
			for (f in fs) {
				f.printClassField( isStatic );
			}
		];
		
		result += values.join('\n\t');
		
		return result;
	}
	
	public static function printTInt(c:ClassType, p:Array<Type>):String {
		var result = '';
		
		result += c.printMetadata();
		result += c.isPrivate ? 'private ' : '';
		result += c.isExtern ? 'extern ' : '';
		result += c.isInterface ? 'interface ' : 'class ';
		result += c.name;
		
		if (c.superClass != null) {
			result += ' extends ' + c.superClass.t.get().name;
		}
		
		if (c.interfaces.length > 0) {
			result += [for (i in c.interfaces) ' implements ' + i.t.get().name].join(' ');
		}
		
		result += '{\n\t';
		
		if (c.statics.get().length > 0) {
			result += c.statics.get().printClassFields( true );
			result += '\n\t';
		}
		
		if (c.fields.get().length > 0) {
			result += c.fields.get().printClassFields( false );
			result += '\n\t';
		}
		
		result += '\n}';
		
		return result;
	}
}