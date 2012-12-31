package uhu.macro.jumla.typedefs;

/**
 * ...
 * @author Skial Bainn
 */

/**
 * Current types :
 * String, Dynamic, Float, Int, Typedef, Array, and 'new' objects.
 * New objects eg. `new List();` will return 'List';
 */
typedef TComplexString = {
	var name:String;
	var params:Array<TComplexString>;
}