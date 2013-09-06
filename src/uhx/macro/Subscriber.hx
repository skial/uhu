package uhx.macro;

import haxe.ds.StringMap;
import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using Lambda;
using StringTools;
using uhu.macro.Jumla;
using haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class Subscriber {
	
	private static var subCache:StringMap<Bool> = new StringMap<Bool>();

	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		
		if ('display'.defined()) return fields;
		
		var newExprs:Array<Expr> = [];
		var initExprs:Array<Expr> = [];
		
		for (field in fields) {
			
			if (field.meta.exists(':sub')) {
				
				var all = field.meta.getAll(':sub');
				var ns = [];
				
				/*for (meta in all) {
					
					if (meta.params.length > 0) {
						
						for (param in meta.params) {
							
							if (param.printExpr().startsWith('ns=')) {
								ns.push( param.printExpr().split('ns=')[1].replace('"', '') );
								meta.params.remove( param );
							}
							
						}
						
					}
					
				}*/
				
				for (meta in all) {
					
					if (meta.params.length > 0) {
						
						var ns = [''];
						var value = '';
						var parts = [];
						var fname = '';
						var isStatic = true;
						
						for (i in 0...meta.params.length) {
							
							switch ( i ) {
								case 0:
									value = meta.params[0].printExpr();
									
									parts = value.split('.');
									fname = parts[parts.length - 1];
									
									if (value.startsWith( 'this' ) && fields.exists( parts[1] )) {
										
										var _f = fields.get( parts[1] );
										
										switch (_f.kind) {
											case FVar(t, e): 
												parts = t.toType().getName().split( '.' );
												_f.kind = FVar( abstractInstance( _f.name, t.toType() ).toComplexType(), e );
												
											case FProp(g, s, t, e):
												parts = t.toType().getName().split( '.' );
												_f.kind = FProp( g, s, abstractInstance( _f.name, t.toType() ).toComplexType(), e );
												
											case _:
										}
										
										isStatic = false;
									}
									
								case 1, _:
									switch (meta.params[1].expr) {
										case EBinop(_, _, n):
											ns.push( n.printExpr().replace('"', '') );
											
										case _:
											isStatic = false;
											fname = meta.params[1].printExpr();
									}
							}
							
						}
						
						if (isStatic) fname = parts.pop();
						
						var type = null;
						
						// Now modify the field
						switch (field.kind) {
							case FVar(t, e):
								type = t;
								
								field.kind = FProp('default', 'set', t, e);
								
								fields.push( field._setter( macro {
									$i { field.name } = v;
									return v;
								} ) );
								
							case FProp(g, s, t, e):
								type = t;
								
								var set = fields.get(s + '_${field.name}');
								
								field.kind = FProp(g, set == null ? 'set' : s, t, e);
								
								if (set == null) {
									fields.push( field._setter( macro {
										$i { field.name } = v;
										return v;
									} ) );
								}
								
							case _:
						}
						
						for (n in ns) {
							
							if (n != '') n = 'NS$n';
							//var key = '${parts.join(".")}.UhxSignalFor_$fname.add(set_${field.name})';
							var key = '${parts.join(".")}.UhxSignalFor_$n$fname.on(set_${field.name})';
							
							if (!subCache.exists( key )) {
								
								var _arr = field.isStatic() ? initExprs : newExprs;
								
								_arr.push( key.parse( field.pos ) );
								
								subCache.set( key, true );
								
							}
							
						}
						
					}
					
				}
				
			}
			
		}
		
		var _new = fields.get('new');
		var _init = fields.get('__init__');
		
		// If _init is null create an __init__ field.
		if (_init == null) {
			// no `__init__` method was found, make it!
			_init = PubSubHelper._init();
			fields.push( _init );
		}
		
		// If _new is null, then assume its a
		// static class and has an __init__ field
		if (_new == null) _new = _init;
		
		// Add newExprs contents to _new
		switch ( _new.kind ) {
			case FFun(method):
				method.ret = null;
				
				for (e in newExprs) {
					method.expr = e.concat( method.expr );
				}
				
			case _:
		}
		
		// Add initExprs contents to _init
		switch ( _init.kind ) {
			case FFun(method):
				method.ret = null;
				
				switch (method.expr.expr) {
					case EBlock(es):
						method.expr = { expr: EBlock( es.concat( initExprs ) ), pos: _init.pos };
						
					case _:
				}
				
			case _:
		}
		
		return fields;
	}
	
	private static var abstractInstanceCache:StringMap<Type> = new StringMap<Type>();
	
	private static function abstractInstance(fname:String, otype:Type):Type {
		var name = 'AbstractForInstanceField_$fname';
		var pack = ['uhx', 'macro', 'help'];
		var path = pack.join( '.' ) + '.$name';
		var result = null;
		
		if (!abstractInstanceCache.exists( path )) {
		
			var ctype = otype.toComplexType();
			var nfields = ['new', 'fromType']
				.mkFields().mkInline()
				.mkPublic().toFFun();
			
			nfields.get( 'new' ).body( macro { this = v; } ).args().push( 'v'.mkArg( ctype ) );
			nfields.get( 'fromType' ).mkStatic().body( macro return new $name( v ) );
			nfields.get( 'fromType' ).args().push( 'v'.mkArg( ctype ) );
			nfields.get( 'fromType' ).meta.push( ':from'.mkMeta() );
			
			var td:TypeDefinition = {
				pack: pack,
				name: name,
				pos: Context.currentPos(),
				meta: [],
				params: [],
				isExtern: false,
				kind: TDAbstract( ctype, [], [ ctype ] ),
				fields: nfields.concat( otype.forward() ),
			};
			
			Context.defineType( td );
			result = Context.getType( path );
			
			abstractInstanceCache.set( path, result );
			
		} else {
			
			result = abstractInstanceCache.get( path );
			
		}
		
		return result;
	}
	
}