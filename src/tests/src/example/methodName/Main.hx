package example.methodName;

using Reflect;

@:autoBuild( example.methodName.Macro.build() )
interface MethodName {}

class Main implements MethodName {

	public static function main() {
		// Using reflection
		var obj:Dynamic = something;
		trace( methodName( Main, obj ) );
		obj();
		
		// Using an abstract type
		var cb1:Callback1 = something;
		trace( cb1.name(Main) );
		untyped cb1();	// Callback1 cant call `this`, compiler doesnt allow it.
		
		// Using an abstract type and the macro interface MethodName
		var cb2:Callback2 = @:cb something;
		trace( cb2.name );
		cb2.call();		//	Only way to call the original method, as far as I know.
		
	}
	
	public static function something():Void {
		trace('Hello World');
	}
	
	public static function methodName(cls:Class<Dynamic>, obj:Dynamic):String {
		var result:String = null;
		
		if (obj.isFunction()) {
			
			for (name in Reflect.fields( cls )) {
				
				var field:Dynamic = Reflect.field( cls, name );
				if (field.isFunction() && Reflect.compareMethods( obj, field )) {
					result = name;
					break;
				}
				
			}
			
		}
		
		return result;
	}
	
}

abstract Callback1(Void->Void) from Void->Void to Void->Void {
	
	public function name(cls:Class<Dynamic>):String {
		var result:String = null;
		
		for (name in Reflect.fields( cls )) {
			
			var field:Dynamic = Reflect.field( cls, name );
			if (field.isFunction() && Reflect.compareMethods( this, field )) {
				result = name;
				break;
			}
			
		}
		
		return result;
	}
	
	public inline function new(v:Void->Void) {
		this = v;
	}
	
}

abstract Callback2( { method:Void->Void, name:String } ) {
	
	public var name(get, never):String;
	
	private inline function get_name():String {
		return this.name;
	}
	
	public inline function new(v:{method:Void->Void, name:String}) {
		this = v;
	}
	
	public inline function call():Void {
		return this.method();
	}
	
}
