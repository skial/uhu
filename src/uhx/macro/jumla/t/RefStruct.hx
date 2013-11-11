package uhx.macro.jumla.t;
import uhx.macro.jumla.a.Meta;

/**
 * @author Skial Bainn
 */

typedef RefStruct<T> = {
	var name(get, set):String;
	var meta(get, set):Meta;
	var isStatic(get, set):Bool;
	var isPublic(get, set):Bool;
	var field:T;
}