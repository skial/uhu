package example.reTypeModules;

import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class MyMacro {

	public static function build() {
		var cls = Context.getLocalClass().get();
		var modules = Context.getModule( cls.module );
		
		for (type in modules) {
			
			switch (type) {
				case TInst(t, _):
					cls = t.get();
				case _:
			}
			
			var nt:TypeDefinition = {
				pack: cls.pack,
				name: cls.name + '_',
				pos: cls.pos,
				meta: [ {
					name:':native',
					params:[macro $v { 'example.reTypeModules.' + cls.name } ],
					pos: cls.pos
				}],
				params: [],
				isExtern: false,
				kind: TDClass( null, [], false ),
				fields: [ {
					name: 'new',
					access: [APublic],
					kind: FFun( {
						args: [],
						ret: null,
						expr: macro {
							trace('Hello Universe from ' + $v { cls.name } +'!');
						},
						params: []
					} ),
					pos: Context.getBuildFields()[0].pos,
					meta: []
				} ]
			}
			
			Compiler.exclude('example.reTypeModules.' + cls.name);
			Context.defineType( nt );
		}
		
		return Context.getBuildFields();
	}
	
}