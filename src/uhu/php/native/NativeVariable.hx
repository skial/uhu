package uhu.php.native;

/**
 * ...
 * @author Skial Bainn
 */

extern class NativeVariable {

	public static inline function debug_zval_dump():Void { }
	
	public static inline function doubleval():Void { }
	
	public static inline function empty():Void { }
	
	// http://www.php.net/manual/en/function.floatval.php
	@:overload(function(_var:Int):Float{})
	@:overload(function(_var:NativeString):Float{})
	@:overload(function(_var:NativeArray<Dynamic>):Float { } )
	public static inline function floatval(_var:String):Float { 
		return untyped __call__('floatval', _var);
	}
	
	public static inline function get_defined_vars():Void { }
	
	public static inline function get_resource_type():Void { }
	
	public static inline function gettype():Void { }
	
	public static inline function import_request_variables():Void { }
	
	// http://php.net/manual/en/function.intval.php
	@:overload(function(_var:Float, ?base:Int = 10):Int{})
	@:overload(function(_var:NativeArray<Dynamic>, ?base:Int = 10):Int{})
	@:overload(function(_var:NativeString, ?base:Int = 10):Int{})
	public static inline function intval(_var:String, ?base:Int = 10):Int { 
		return untyped __call__('intval', _var, base);
	}
	
	public static inline function is_array():Void { }
	
	public static inline function is_bool():Void { }
	
	public static inline function is_callable():Void { }
	
	public static inline function is_double():Void { }
	
	public static inline function is_float():Void { }
	
	public static inline function is_int():Void { }
	
	public static inline function is_integer():Void { }
	
	public static inline function is_long():Void { }
	
	public static inline function is_null():Void { }
	
	public static inline function is_numeric():Void { }
	
	public static inline function is_object():Void { }
	
	public static inline function is_real():Void { }
	
	public static inline function is_resource():Void { }
	
	public static inline function is_scalar():Void { }
	
	public static inline function is_string():Void { }
	
	public static inline function isset():Void { }
	
	public static inline function print_r():Void { }
	
	// http://www.php.net/manual/en/function.serialize.php
	public static inline function serialize(value:Dynamic):String { 
		return untyped __call__('serialize', value);
	}
	
	public static inline function settype():Void { }
	
	// http://www.php.net/manual/en/function.strval.php
	@:overload(function(_var:Float):String{})
	@:overload(function(_var:NativeString):String{})
	@:overload(function(_var:NativeArray<Dynamic>):String{})
	public static inline function strval(_var:Int):String { 
		return untyped __call__('strval', _var);
	}
	
	// http://www.php.net/manual/en/function.unserialize.php
	public static inline function unserialize(string:String):Dynamic { 
		return untyped __call__('unserialize', value);
	}
	
	public static inline function unset():Void { }
	
	public static inline function var_dump():Void { }
	
	public static inline function var_export():Void {}
	
}