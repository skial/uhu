package uhx.macro;

import haxe.macro.Printer;
import haxe.macro.Type;
import haxe.macro.Expr;

using Lambda;
using StringTools;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */

class Alias {
	
	public static var META:String = ':alias';

	public static function handler(cls:ClassType, field:Field):Array<Field> {
		var fields:Array<Field> = [ ];
		
		var meta = field.meta.get( META );
		
		for (value in meta.params) {
			
			var name = value.toString().replace('"', '');
			var new_access = [APrivate];
			
			if (field.access.indexOf( AStatic ) != -1) {
				new_access.push( AStatic );
			}
			
			if (field.access.indexOf( AInline ) == -1) {
				new_access.push( AInline );
			}
			
			var kind:FieldType = null;
			
			switch (field.kind) {
				case FVar(t, _):
					kind = FVar(t, macro $i{field.name});
					
				case FProp(g, s, t, _):
					var hasGetter = (g.indexOf( 'get' ) != -1);
					var hasSetter = (s.indexOf( 'set' ) != -1);
					
					kind = FProp(hasGetter ? 'get' : g, hasSetter ? 'set' : s, t, null);
					
					if (hasGetter) {
						
						fields.push( {
							name:'get_$name',
							access: new_access,
							kind: FFun( {
								args:[],
								ret:null,
								params:[],
								expr:macro { return $i{field.name}; },
							} ),
							pos:field.pos,
						} );
						
					}
					
					if (hasSetter) {
						fields.push( {
							name:'set_$name',
							access: new_access,
							kind: FFun( {
								args:[ {
									name:'v',
									opt:false,
									type:t
								} ],
								ret:null,
								params:[],
								expr:macro { $i { field.name } = v; return $i { field.name }; },
							} ),
							pos:field.pos,
						} );
					}
					
				case FFun(f):
					var names:Array<Expr> = [];
					
					for (arg in f.args) {
						names.push( macro $i { arg.name } );
					}
					
					kind = FFun( {
						args:f.args,
						ret:f.ret,
						params:f.params,
						expr: macro { return $i { field.name } ($a { names } ); },
					} );
					
			}
			
			new_access = [APublic];
			
			if (field.access.indexOf( AStatic ) != -1) {
				new_access.push( AStatic );
			}
			
			if (field.access.indexOf( AInline ) != -1) {
				new_access.push( AInline );
			}
			
			fields.push( {
				name: name,
				access: new_access,
				kind: kind,
				pos: field.pos,
				meta: [ { name:':alias_of', params:[macro $v{field.name}], pos:meta.pos } ]
			} );
			
		}
		
		fields.push( field );
		
		return fields;
	}
	
}