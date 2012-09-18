package ;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import uhu.hocco.HoccoBuild;
import uhu.Library;

using tink.core.types.Outcome;
using tink.macro.tools.MacroTools;

/**
 * ...
 * @author Skial Bainn
 */
 
@:hocco
class Hocco {
	
	/**
	 * You call this method from your ```.hxml``` file. Add ```--macro Hocco.me()``` for this method to be called.
	 * 
	 * It adds the conditional flag ```use_rtti_doc``` into the compiler.
	 */
	@:macro public static function me():Void {
		Compiler.define('use_rtti_doc');
		Context.onGenerate(rummage);
	}
	
	/**
	 * Used to set the global defaults which will effect every class, enum or typedef.
	 * 
	 * You call this method from your ```.hxml``` file. Add ```--macro Hocco.setDefaults( { show_privates:true } )``` for this method to be called.
	 */
	@:macro public static function setDefaults(defaults:TDefaults):Void {
		if (defaults.output_path != null) HoccoBuild.output_path = Sys.getCwd() + defaults.output_path;
		if (defaults.lookup_files != null) HoccoBuild.lookup_files = defaults.lookup_files;
		if (defaults.directory_path != null) HoccoBuild.directory_path = Sys.getCwd() + defaults.directory_path;
		if (defaults.show_privates != null) HoccoBuild.show_privates = defaults.show_privates;
		if (defaults.print_access != null) HoccoBuild.print_access = defaults.print_access;
		if (defaults.print_metadata != null) HoccoBuild.print_metadata = defaults.print_metadata;
		
		_defaults = defaults;
	}
	
	/**
	 * Checks the objects metadata for ```@:hocco```.
	 * 
	 * If it is detected, it checks for any parameters that might have been passed along.
	 */
	private static function isHoccoed(val: { meta:MetaAccess, doc:Null<String> }, ?namespace:String):Bool {
		
		if (val.meta.has(':hocco')) {
			
			HoccoBuild.local_file_path = namespace.toLowerCase();
			
			for (meta in val.meta.get()) 
				if (meta.name == ':hocco') 
					if (val.doc == null) 
						for (param in meta.params)
							
							switch (param.expr) {
								
								case EBinop( _, e1, e2 ):
									var id = e1.toString();
									
									if (id == 'doc') val.doc = e2.getString().sure(); 
									
									if (id == 'lookup_files' && e2.getIdent().sure() == 'true')
										HoccoBuild.lookup_files = true;
									else
										HoccoBuild.lookup_files = _defaults.lookup_files;
									
									if (id == 'show_privates' && e2.getIdent().sure() == 'true')
										HoccoBuild.show_privates = true;
									else
										HoccoBuild.show_privates = _defaults.show_privates;
									
								default:
								
							}	
			
			return true;
			
		} else {
			
			return false;
			
		}
	}
	
	/**
	 * The callback function for ```Context.onGenerate```. Loop through every type.
	 */
	private static function rummage(val:Array<Type>):Void {
		for (v in val) chop(v);
	}
	
	/**
	 * Takes every compiled type in, checks it's type. Hocco is only interested in Classes, Enum's and Typedefs which are structures.
	 */
	private static function chop(type:Type):Void {
		switch(type) {
			
			case TMono(_t):
				var mono = _t.get();
				if (mono != null) {
					chop(mono);
				}
			
			case TEnum(_t, _p):
				var enm:EnumType = _t.get();
				if (isHoccoed(enm, enm.pack.concat([enm.name]).join('/'))) {
					HoccoBuild.documentEnum(enm);
				}
				
			case TInst(_t, _p):
				var cls:ClassType = _t.get();
				if (isHoccoed(cls, cls.pack.concat([cls.name]).join('/'))) {
					HoccoBuild.documentClass(cls);
				}
				
			case TType(_t, _p):
				var def = _t.get();
				if (def != null) {
					if (isHoccoed(def, def.pack.concat([def.name]).join('/'))) {
						HoccoBuild.documentTypedef(def);
					}
				}
				
			case TFun(_a, _r):
			
			case TAnonymous(_a):
			
			case TDynamic(_t):
				if (_t != null) {
					chop(_t);
				}
				
			case TLazy(_f):
				
			default:
				
		}
	}
	
	/**
	 * This field holds the default values Hocco needs.
	 */
	private static var _defaults:TDefaults = { 
		output_path:'', 
		show_privates:false, 
		directory_path:'', 
		lookup_files:false, 
		print_access:true,
		print_metadata:false 
	};
	
}