package uhu.macro.jumla;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.ComplexTypeTools;

using haxe.macro.Context;
using uhu.macro.Jumla;

/**
 * @author Skial Bainn
 */

class TypeTools {
	
	// Compat code for tink_macros
	@:extern public static inline function getID(type:Type, ?reduce:Bool = false) {
		return getName(type);
	}
	
	public static function toString(t:Type):String {
		return getName( t );
	}
	
	public static function isEnum(type:Type):Bool {
		return type.getName() == 'TEnum';
	}
	
	public static function isClass(type:Type):Bool {
		return type.getName() == 'TInst';
	}
	
	public static function isTypedef(type:Type):Bool {
		return type.getName() == 'TType';
	}
	
	public static function isMethod(type:Type):Bool {
		return type.getName() == 'TFun';
	}
	
	public static function isArray(type:Type):Bool {
		return type.getName() == 'Array';
	}
	
	public static function isIterable(type:Type):Bool {
		return Context.unify( type, Context.getType( 'Iterable' ) );
	}
	
	public static function arity(type:Type):Int {
		var result = 0;
		
		switch (type) {
			case TFun(args, _):
				result = args.length;
				
			case _:
		}
		
		return result;
	}
	
	public static function args(type:Type):Array<{ name : String, opt : Bool, t : Type }> {
		var result = [];
		
		switch (type) {
			case TFun(args, _):
				result = args;
				
			case _:
		}
		
		return result;
	}
	
	public static inline function isStructure(type:Type):Bool {
		return (type.getName() == 'TAnonymous' || isTypedef( type ));
	}
	
	public static inline function isAbstract(type:Type):Bool {
		return type.getName() == 'TAbstract';
	}
	
	public static inline function isDynamic(type:Type):Bool {
		return type.getName() == 'TDynamic';
	}
	
	public static function getName(type:Type):String {
		switch (type) {
			case TInst(t, _):
				return t.toString();
			case TEnum(t, _):
				return t.toString();
			case TType(t, _):
				return t.toString();
			case TAbstract(t, _):
				return t.toString();
			default:
				
		}
		
		return '';
	}
	
	public static function params(type:Type):Array<Type> {
		switch (type) {
			case TInst(_, p):
				return p;
			case TEnum(_, p):
				return p;
			case TType(_, p):
				return p;
			case TAbstract(_, p):
				return p;
			case _:
				
		}
		
		return [];
	}
	
	public static function reduce(type:Type):Type {
		var result = type;
		
		switch (type) {
			case TMono(t):
				if (t.get() != null) result = t.get().reduce();
				
			case TLazy(f):
				result = f().reduce();
				
			case TDynamic(t):
				if (t != null) result = t.reduce();
				
			case TInst(t, p):
				if (type.isIterable()) {
					
					result = p[0].reduce();
					
				}
				
			case TAbstract(t, p):
				if (type.isIterable()) {
					
					//result = p[0];
					//result = t.get().type;
					var pack = t.get().type.getName().split('.');
					var name = pack.pop();
					var params = [for (pp in p) TPType( pp.toComplexType() )];
					var tpath = { pack : pack, name : name, params : params };
					result = ComplexTypeTools.toType( TPath( tpath ) );
				}/* else {*/
					
					//var reduced = t.get().type.reduce();
					
					/*if (reduced.getName() != '') {
						result = reduced;
					}*/
					
				//}
				
			case TFun(_, r):
				result = r.reduce();
				
			case _:
		}
		
		return result;
	}
	
	public static function resolve(type:Type, calls:Array<String>):Type {
		var result:Type = type;
		
		while (calls.length != 0) {
			var id = calls.shift();
			
			switch( type ) {
				case TInst(t, _):
					var cls = t.get();
					var isStatic = false;
					var statics = cls.statics.get();
					var fields = cls.fields.get();
					var field = null;
					
					if (id != 'new') {
						if (statics.exists( id )) {
							
							field = statics.get( id );
							isStatic = true;
							
						} else if (fields.exists( id )) {
							
							field = fields.get( id );
							
						}
					} else if (cls.constructor != null) {
						field = cls.constructor.get();
					}
					
					if (field != null) {
						
						result = type = field.type;
						//result = field.toField( isStatic );
						
					}
					
				case _:
			}
			
		}
		
		switch (result) {
			case TLazy(f):
				result = f();
				
			case _:
		}
		
		return result;
	}
	
	public static function find(path:String):Type {
		var result:Type = null;
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		var parts = path.split( '.' );
		var calls = [];
		
		if (fields.exists( parts[0] )) {
			result = fields.get( parts.shift() ).typeof().resolve( parts );
			
		} else {
			
			if (parts.length == 1 && fields.exists( parts[0] )) {
				
				result = fields.get( parts[0] ).typeof();
				
			}
			
			while (parts.length != 0) {
				
				var name = parts.pop();
				
				try {
					
					var tpath = TPath( { pack: parts, name: name, params: [], sub: null } );
					
					if (calls.length > 1) calls.reverse();
					
					//var type:Type = ComplexTypeTools.toType( tpath );
					var type:Type = Context.follow( tpath.toType() );
					
					result = type.resolve( calls );
					
					break;
					
				} catch (e:Dynamic) {
					
					calls.push( name );
					
				}
				
			}
			
		}
		
		return result;
	}
	
	public static function defaults(type:Type):Expr {
		var result = macro null;
		
		switch (type) {
			case TMono(t):
				
				if (t.get() != null) {
					result = t.get().defaults();
				}
				
			//case TEnum(t, p):
				
			case TInst(t, p):
				
				switch(t.get().name) {
					case 'String':
						result = macro '';
						
					case _:
						trace(t.get().name);
				}
				
			//case TType(t, p):
				
			//case TFun(args, ret):
				
			case TAnonymous(a):
				
				for (field in a.get().fields) {
					
				}
				
			case TDynamic(t):
				
				if (t != null) result = t.defaults();
				
			case TLazy(f):
				
				result = f().defaults();
				
			case TAbstract(t, p):
				
				switch (t.get().name) {
					case 'Bool':
						result = macro true;
						
					case 'Int':
						result = macro 0;
						
					case 'Float':
						result = macro .0;
						
					case 'Void':
						
					case _:
						trace(t.get().name);
				}
				
			case _:
				trace( type );
		}
		
		return result;
	}
	
	public static function toValueType(type:Type):Expr {
		var result = macro TNull;
		
		switch( type ) {
			case TInst(t, p):
				result = macro TClass( $i { type.getName() } );
				
			case TAbstract(t, p):
				
				switch (t.get().name) {
					case 'Bool':
						result = macro TBool;
						
					case 'Int':
						result = macro TInt;
						
					case 'Float':
						result = macro TFloat;
						
					case _:
						
				}
				
			case _:
				trace( type );
		}
		
		return result;
	}
	
	public static function forward(type:Type):Array<Field> {
		var results:Array<Field> = [];
		
		switch (type) {
			case TInst(t, p):
				var cls = t.get();
				
				results = forward_classField( cls.fields.get(), 'this', false );
				//results = results.concat( forward_classField( cls.statics.get(), cls.path(), true ) );
				
			case _:
		}
		
		return results;
	}
	
	private static function forward_classField(fields:Array<ClassField>, caller:String, isStatic:Bool) {
		var results:Array<Field> = [];
		
		for (field in fields) if (field.isPublic) {
			
			var _f = '${field.name}'.mkField().mkPublic();
			if (isStatic) _f.mkStatic();
			
			switch (field.kind) {
				case FMethod(k):
					_f.toFFun().mkInline();
					
					var call = '$caller.${field.name}(';
					//trace( field.name );
					var handleArgs:Type->Void = null;
					handleArgs = function(type:Type) {
						switch (type) {
							case TFun(args, ret):
								
								for (arg in args) {
									//trace( arg );
									_f.args().push( arg.name.mkArg( arg.t.toComplexType(), arg.opt ) );
									call += arg.name + (args.length > 1 && arg != args[args.length-1] ? ', ' : '');
								}
								
							case TLazy(ftype):
								handleArgs( ftype() );
								
							case _: 
								trace( type );
						}
					}
					handleArgs(field.type);
					
					call += ')';
					
					var expr = Context.parse( call, Context.currentPos() );
					
					_f.body( macro return $expr );
					
				case FVar(r, w):
					var g = 'get';
					var s = 'never';
					
					switch (w) {
						case AccCall:
							s = 'set';
						case _:
					}
					
					_f.toFProp(g, s, field.type.toComplexType(), field.expr() == null ? null : Context.getTypedExpr( field.expr() ) );
					var _fg = 'get_${field.name}'.mkField().mkPublic().toFFun();
					if (isStatic) {
						_fg.mkStatic();
						_fg.args().push( 'v'.mkArg( Context.getType( caller ).toComplexType() ) );
						_fg.body( macro return $e { Context.parse( 'v.${field.name}', Context.currentPos() ) } );
					} else {
						_fg.body( macro return $e { Context.parse( '$caller.${field.name}', Context.currentPos() ) } );
					}
					results.push( _fg );
			}
			//trace( _f.printField() );
			results.push( _f );
			
		}
		
		return results;
	}
	
}