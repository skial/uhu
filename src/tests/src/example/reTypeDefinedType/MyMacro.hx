package example.reTypeDefinedType;

import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class MyMacro {
	
	public static function fragment() {
		trace( Context.getLocalClass().get().name );
		return Context.getBuildFields();
	}

	public static function build() {
		var old_cls = Context.getLocalClass().get();
		var new_cls:TypeDefinition = {
			pack: [],
			name: 'NewType',
			pos: old_cls.pos,
			meta: [],
			params: [],
			isExtern: false,
			kind: TDClass( null, [], false ),
			fields: [ {
				name: 'hello',
				access: [APublic, AStatic],
				kind: FFun( {
					args: [],
					ret: null,
					expr: macro {
						trace('Hello Universe from Main');
					},
					params: []
				} ),
				pos: Context.getBuildFields()[0].pos,
				meta: []
			} ]
		}
		
		Context.defineType( new_cls );
		Compiler.addMetadata('@:build(example.reTypeDefinedType.MyMacro.fragment())', 'NewType');
		var t = Context.getType('NewType');
		t = Context.follow( t );
		
		new_cls = {
			pack: [],
			name: 'NewType2',
			pos: old_cls.pos,
			meta: [ { 
				name:':native', 
				params:[macro 'NewType'], 
				pos:old_cls.pos 
			}],
			params: [],
			isExtern: false,
			kind: TDClass( null, [], false ),
			fields: [ {
				name: 'hello',
				access: [APublic, AStatic],
				kind: FFun( {
					args: [],
					ret: null,
					expr: macro {
						trace('Hello World from Main');
					},
					params: []
				} ),
				pos: Context.getBuildFields()[0].pos,
				meta: []
			} ]
		}
		
		Compiler.exclude('NewType');
		
		Context.defineType( new_cls );
		Compiler.addMetadata('@:build(example.reTypeDefinedType.MyMacro.fragment())', 'NewType2');
		t = Context.getType('NewType2');
		t = Context.follow( t );
		//trace(t);
		return Context.getBuildFields();
	}
	
}