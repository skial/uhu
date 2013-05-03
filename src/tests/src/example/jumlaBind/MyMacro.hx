package example.jumlaBind;
import haxe.ds.StringMap;
import haxe.macro.Compiler;
import haxe.macro.Printer;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import sys.FileSystem;
import sys.io.File;

using StringTools;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class MyMacro {
	
	public static var cls:ClassType = null;
	public static var fields:Array<Field> = null;
	public static var force:StringMap<Bool> = new StringMap<Bool>();

	public static function build():Array<Field> {
		cls = Context.getLocalClass().get();
		fields = Context.getBuildFields();
		
		var exprs:Array<Expr> = [];
		
		for (field in fields) {
			
			if (field.meta.exists(':bind')) {
				var meta = field.meta.get(':bind');
				
				if (meta.params.length > 0) {
					
					var value = meta.params[0].printExpr().replace('"', '');
					var parts = value.split( '.' );
					var fname = parts[parts.length - 1];
					var isStatic = (fname.indexOf('::') == -1);
					
					if (!isStatic) {
						
						var bits = parts.pop().split('::');
						parts.push( bits.shift() );
						fname = bits[0];
						
					}
					
					if (!force.exists( parts.join('.') )) {
						force.set( parts.join('.'), true );
					}
					Compiler.addMetadata('@:uhx_dispatcher', parts.join('.'), fname, isStatic);
					
					field.kind = FProp('default', 'set', macro:String);
					if (!field.meta.exists(':isVar')) {
						field.meta.push( { name:':isVar', params:[], pos:field.pos } );
					}
					fields.push( {
						name:'set_' + field.name,
						doc:null,
						access:field.access,
						kind:FFun( {
							args:[ {
								name:'v',
								opt:false,
								type:macro:String
						}],
						ret:macro:String,
						expr:macro {
							$i { field.name } = v;
							return v;
						},
							params:[]
						} ),
						pos:field.pos,
						meta:[]
					} );
					
					exprs.push(Context.parse(parts.join('.') + '.SignalFor_' + fname + '.add(set_' + field.name + ')', field.pos));
					
				}
			}
			
			if (field.meta.exists(':bound')) {
				
			}
			
		}
		
		for (key in force.keys()) {
			Compiler.addMetadata('@:build(example.jumlaBind.MyMacro.modify())', key);
		}
		
		var _new = fields.get('new');
		switch( _new.kind ) {
			case FFun( method ):
				method.ret = null;
				for (e in exprs) {
					method.expr = e.concat( method.expr );
				}
				
			case _:
				
		}
		
		return fields;
	}
	
	public static function modify() {
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		
		for (field in fields) {
			
			if (field.meta.exists(':uhx_dispatcher')) {
				
				field.kind = FProp('default', 'set', macro:String);
				if (!field.meta.exists(':isVar')) {
					field.meta.push( { name:':isVar', params:[], pos:field.pos } );
				}
				
				fields.push( {
					name:'SignalFor_' + field.name,
					doc:null,
					access:[AStatic, APublic],
					kind: FVar(macro :msignal.Signal.Signal1<String>, macro new msignal.Signal.Signal1<String>()),
					pos:field.pos,
					meta:[]
				} );
				
				fields.push( {
					name:'set_' + field.name,
					doc:null,
					access:field.access,
					kind:FFun( {
						args:[ {
							name:'v',
							opt:false,
							type:macro:String
						}],
						ret:macro:String,
						expr:macro {
							$i { field.name } = v;
							$i { 'SignalFor_' + field.name } .dispatch( v );
							return v;
						},
						params:[]
					} ),
					pos:field.pos,
					meta:[]
				} );
				
			}
			
		}
		
		return fields;
	}
	
}