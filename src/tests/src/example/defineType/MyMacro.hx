package example.defineType;

import haxe.macro.Compiler;
import haxe.macro.Printer;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author Skial Bainn
 */
 
class MyMacro {
	
	public static function frack():Array<Field> {
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		
		trace(cls.name);
		
		return fields;
	}

	public static function build():Array<Field> {
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		
		var old_cls:ClassType = switch( Context.getType( 'Main' ) ) {
			case TInst(t, _): t.get();
			case _: null;
		}
		
		var old_expr = old_cls.statics.get()[0].expr();
		var old_typed = old_expr != null ? Context.getTypedExpr( old_expr ) : null;
		
		if (old_typed == null) {
			var pos = Context.getPosInfos( old_cls.statics.get()[0].pos );
			trace( pos );
			var content = File.getContent( FileSystem.fullPath( pos.file ) );
			var section = content.substr( pos.min, content.length - pos.max );
			trace( content.substr(0, pos.min) );
			trace( content.substr(pos.max) );
			trace( section );
		}
		
		var new_cls:TypeDefinition = {
			pack: old_cls.pack,
			name: 'RE' + old_cls.name,
			pos: old_cls.pos,
			meta: [ { 
				name:':native', 
				params:[macro 'example.defineType.Main'], 
				pos:old_cls.pos 
			} ],
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
						$v { old_typed };
					},
					params: []
				} ),
				pos: fields[0].pos,
				meta: []
			} ]
		}
		
		trace( new Printer().printField( new_cls.fields[0] ) );
		
		// Remove original class
		Compiler.exclude('example.defineType.Main');
		// Register modified type
		Context.defineType( new_cls );
		
		return fields;
	}
	
}