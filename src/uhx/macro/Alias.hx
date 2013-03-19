package uhx.macro;

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
		var fields:Array<Field> = [ field ];
		
		if (field.meta.exists( META )) {
			
			var meta = null;
			
			for (m in field.meta) {
				if (m.name == META) {
					meta = m;
					break;
				}
			}
			
			for (value in meta.params) {
				
				var name = value.toString().replace('"', '');
				var access = field.access;
				
				if (access.indexOf( AInline ) != -1) {
					access.push( AInline );
				}
				
				var kind:FieldType = null;
				
				switch (field.kind) {
					case FVar(t, _):
						kind = FVar(t, macro $i{field.name});
						
					case FProp(_, _, t, _):
						kind = FProp('get_$name', 'set_$name', t, null);
						
						fields.push( {
							name:'get_$name',
							access: access,
							kind: FFun( {
								args:[],
								ret:t,
								params:[],
								expr:macro { return $i{field.name}; },
							} ),
							pos:field.pos,
						} );
						
						fields.push( {
							name:'set_$name',
							access: access,
							kind: FFun( {
								args:[ {
									name:'v',
									opt:false,
									type:t
								} ],
								ret:t,
								params:[],
								expr:macro { $i { field.name } = v; return $i { field.name }; },
							} ),
							pos:field.pos,
						} );
						
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
				
				fields.push( {
					name: name,
					access: access,
					kind: kind,
					pos: field.pos,
					meta: [ { name:':alias_of', params:[macro $v{field.name}], pos:meta.pos } ]
				} );
				
			}
			
		}
		
		return fields;
	}
	
}