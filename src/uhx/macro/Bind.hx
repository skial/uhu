package uhx.macro;

import haxe.ds.StringMap;
import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using StringTools;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class Bind {
	
	private static var META:String = ':bind';
	private static var META_MARKED:String = ':uhx_bind_marked';
	private static var SIGNAL:String = 'UhxSignalFor_';
	
	private static var forceClasses:StringMap<Bool> = new StringMap<Bool>();

	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		var constructorExprs:Array<Expr> = new Array<Expr>();
		
		if (Context.defined('display')) return fields;
		
		for (field in fields) {
			
			if (field.name == 'new') continue;
			if (field.meta.exists(':alias_of')) continue;
			
			if (field.meta.exists( META ) && !field.meta.exists( META_MARKED )) {
				
				var meta = field.meta.get( META );
				
				if (meta.params.length > 0) {
					
					var value = meta.params[0].printExpr().replace('"', '');
					var parts = value.split('.');
					var fname = parts[parts.length - 1];
					var isStatic = (fname.indexOf('::') == -1);
					
					if (!isStatic) {
						
						var bits = parts.pop().split('::');
						parts.push( bits.shift() );
						fname = bits[0];
						
					}
					
					if (!forceClasses.exists( parts.join('.') )) {
						forceClasses.set( parts.join('.'), true );
					}
					
					switch(field.kind) {
						case FVar(t, e):
							field.kind = FProp('default', 'set', t, e);
							
							if (!field.meta.exists(':isVar')) {
								field.meta.push( { name:':isVar', params:[], pos:field.pos } );
							}
							
							//var access = field.access;
							//if (field.isInline()) field.access.remove(AInline);
							
							if (!fields.exists('set_' + field.name)) {
								fields.push( {
									name: 'set_' + field.name,
									doc: null,
									access: field.access,
									kind: FFun( {
										args:[ 
											{
												name: 'v',
												opt: false,
												type: t
											} 
										],
										ret: t,
										expr: macro {
											$i { field.name } = v;
											return v;
										},
										params: []
									} ),
									pos: field.pos,
									meta: []
								} );
							}
							
						case _:
					}
					
					constructorExprs.push(Context.parse('${parts.join(".")}.$SIGNAL$fname.add(set_${field.name})', field.pos ));
				}
				
			}
			
			if (!field.meta.exists( META_MARKED )) {
				
				var ff = field.isInline();
				
				switch(field.kind) {
					case FVar(t, e):
						if (field.isInline()) {
							field.access.remove( AInline );
						}
						
						field.kind = FProp((field.isStatic() ? 'get' : 'default'), 'set', t, (field.isStatic() ? null : e));
						
						if (!field.meta.exists(':isVar')) {
							field.meta.push( { name:':isVar', params:[], pos:field.pos } );
						}
						
						if (field.isStatic()) {
							
							fields.push( {
								doc: null,
								pos: field.pos,
								name: 'get_${field.name}',
								access: [APublic, AStatic],
								meta: [ { name: META_MARKED, params:[], pos:field.pos } ],
								kind: FFun( {
									ret: t,
									args: [],
									params: [],
									expr: macro {
										return $e;
									}
								} )
							} );
							trace(field.printField());
						}
						
						add_set(t, field, fields);
						add_UhxSignalFor( t, field, fields );
						
					case FProp(g, s, t, e):
						if (!field.meta.exists(':isVar')) {
							field.meta.push( { name:':isVar', params:[], pos:field.pos } );
						}
						
						var setter = fields.get(s + '_' + field.name);
						
						if (setter != null) {
							
							switch(setter.kind) {
								case FFun(method):
									var expr = macro { 
										$i { '$SIGNAL${field.name}' } .dispatch( v ); 
									}
									method.expr = expr.concat( method.expr );
								case _:
							}
							
						} else {
							if (ff) trace(field.printField());
							field.kind = FProp(g, 'set', t, e);
							add_set(t, field, fields);
							
						}
						
						add_UhxSignalFor( t, field, fields );
						
					case _:
				}
				
				if (field.meta != null) {
					field.meta.push( { name:META_MARKED, params:[], pos:field.pos } );
				}
				
			}
		}
		
		for (key in forceClasses.keys()) {
			Compiler.addMetadata('@:uhx_bind', key);
			Compiler.addMetadata('@:build(uhx.macro.klas.Handler.build())', key);
		}
		
		var constructor = fields.get('new');
		
		// assume class is static
		// try and fetch `__init__`
		if (constructor == null) constructor = fields.get('__init__');
			
		if (constructor == null) {
			// no `__init__` method was found
			// make it!
			constructor = {
				name:'__init__',
				doc:null,
				access:[APublic, AStatic],
				kind:FFun( {
					args:[],
					ret:null,
					expr:macro { },
					params:[]
				} ),
				pos:cls.pos,
				meta:[ { name:META_MARKED, params:[], pos:cls.pos } ]
			};
			
			fields.push( constructor );
			
		}
		
		switch (constructor.kind) {
			case FFun(method):
				method.ret = null;
				
				for (expr in constructorExprs) {
					method.expr = expr.concat( method.expr );
				}
				
			case _:
		}
		
		return fields;
	}
	
	private static function add_UhxSignalFor(ctype:ComplexType, field:Field, fields:Array<Field>) {
		if (!fields.exists('$SIGNAL${field.name}')) {
			fields.push( {
				pos:field.pos,
				access:[APublic, AStatic],
				name:'$SIGNAL${field.name}',
				meta:[ { name:META_MARKED, params:[], pos:field.pos } ],
				kind:FVar(macro :msignal.Signal.Signal1<$ctype>, macro new msignal.Signal.Signal1<$ctype>()),
			} );
		}
	}
	
	private static function add_set(ctype:ComplexType, field:Field, fields:Array<Field>) {
		if (!fields.exists('set_${field.name}')) {
			
			var f = {
				pos:field.pos,
				access: field.access,
				name:'set_${field.name}',
				meta:[ { name: META_MARKED, params:[], pos:field.pos } ],
				kind:FFun( {
					params:[],
					args:[ {
						name:'v',
						opt:false,
						type:ctype
					} ],
					ret:ctype,
					expr:macro {
						$i { field.name } = v;
						$i { '$SIGNAL${field.name}' } .dispatch( v );
						return v;
					}
				} )
			};
			
			fields.push( f );
		}
	}
	
}