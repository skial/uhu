package uhu.php;
import uhu.php.native.NativeArray;
import uhu.php.native.NativeVariable;

/**
 * ...
 * @author Skial Bainn
 */

extern class Lib {
	
	// http://php.net/manual/en/function.print.php
	// http://php.net/manual/en/function.print-r.php
	public static inline function print( v : Dynamic ) : Void {
		untyped __call__("print_r", v);
	}
	
	// http://php.net/manual/en/function.print.php
	// http://php.net/manual/en/function.print-r.php
	public static inline function println( v : Dynamic ) : Void {
		untyped __call__('print_r', v);
		untyped __call__('print', '\n');
	}
	
	// http://php.net/manual/en/function.var-dump.php
	public static inline function dump(v : Dynamic) : Void {
		untyped __call__("var_dump", v);
	}
	
	// http://www.php.net/manual/en/function.serialize.php
	public static inline function serialize( v : Dynamic ) : String {
		return NativeVariable.serialize(v);
	}
	
	// http://www.php.net/manual/en/function.unserialize.php
	public static inline function unserialize( s : String ) : Dynamic {
		return NativeVariable.unserialize(s);
	}
	
	// http://php.net/manual/en/function.extension-loaded.php
	public static inline function extensionLoaded(name : String):Bool {
		return untyped __call__("extension_loaded", name);
	}
	
	// http://www.php.net/manual/en/function.readfile.php
	public static inline function printFile(file : String):Int {
		return untyped __call__('readfile', file);
	}
	
}