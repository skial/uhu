package uhu.tem;

import uhu.tem.t.TemClass;
import uhu.tem.t.TemTemplate;

#if (macro || test_mode)
import haxe.macro.Type;
import haxe.macro.Expr;
import uhu.macro.Jumla;
#end

/**
 * ...
 * @author Skial Bainn
 */

//typedef MFile = massive.neko.io.File;
//typedef StdType = Type;
//typedef MacroType = haxe.macro.Type;

class Common {
	
	#if (macro || test_mode)
	public static var currentClass:ClassType;
	public static var currentFields:Array<TField>;
	public static var currentStatics:Array<TField>;
	#end
	
	public static var classes:Hash<TemClass> = new Hash<TemClass>();
	public static var partials:Array<TemTemplate> = [];
	public static var index:TemTemplate = null;
	
	public static var x_instance:String = 'data-binding';
	public static var x_static:String = 'data-binding-static';
	
	public static var ignoreClass:Array<String> = ['Class'];
	// This will be improved by detecting invalid characters before searching this.
	public static var ignoreField:Array<String> = [x_instance, x_static, 'class', 'id'];
	
}