package example.jumlaModules;

import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class MyMacro {
	
	public static var modules:Array<Type>;

	public static function build() {
		//modules = Context.getModule('example.jumlaModules.A');
		modules = Context.getModule('CodeHighlighter');
		
		for (module in modules) {
			loop( module );
		}
		
		//Compiler.exclude('example.jumlaModules.A');
		//Compiler.exclude('CodeHighlighter');
		
		return Context.getBuildFields();
	}
	
	public static function loop(type:Type) {
		var td:TypeDefinition = null;
		var or:BaseType = null;
		
		var ftype = Context.follow( type ); // This is fracking key to it working!!
		
		switch (ftype) {
			case TInst(t, _):
				or = t.get();
				td = t.get().toTypeDefinition('', '_');
			case TEnum(t, _):
				or = t.get();
				td = t.get().toTypeDefinition('', '_');
			case TAnonymous(anon):
				switch(type) {
					case TType(t, _):
						or = t.get();
						td = t.get().toTypeDefinition('', '_');
					case _:
				}
				//td = anon.get().toTypeDefinition();
			/*case TType(t, _):
				or = t.get();
				td = t.get().toTypeDefinition('', '_');*/
			case _:
				trace( ftype );
				trace( ftype.getName() );
		}
		
		if (td != null) {
			//or.exclude();
			or.meta.add(':remove', [], or.pos);
			td.meta.push( { name:':allow', params:[macro 'CodeHighlighter' ], pos:or.pos } );
			td.meta.push( { name:':native', params:[macro $v { or.path() } ], pos:or.pos } );
			td.meta.push( { name:'hello', params:[macro $v { td.path() } ], pos:or.pos } );
			Context.defineType( td );
			
		}
	}
	
}