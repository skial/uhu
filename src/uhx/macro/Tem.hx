package uhx.macro;

#if macro
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using Xml;
using sys.io.File;
using sys.FileSystem;
using uhu.macro.Jumla;
#end

/**
 * ...
 * @author Skial Bainn
 */
class Tem {
	
	public static macro function setIndex(path:String):Void {
		var file = Context.resolvePath( path ).fullPath().getContent();
		TemBuilder.html = file.parse();
	}
	
	public static macro function build():Array<Field> {
		return TemBuilder.handler( Context.getLocalClass().get(), Context.getBuildFields() );
	}
	
}

class TemBuilder {
	
	#if macro
	public static var html:Xml = null;
	
	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		trace( cls.name );
		html = html.firstElement();
		trace( html );
		if (html != null) {
			
			
			
		}
		
		return fields;
	}
	#end
	
}

class Scope {
	
}

class Validate {
	
}