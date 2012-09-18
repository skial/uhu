package uhu.mu.typedefs;

/**
 * ...
 * @author Skial Bainn
 */

typedef TSection = {
	//var otag:String;
	var opening:String;
	var content:String;
	//var ctag:String;
	var tokens:Array<ETag>;
	var template:String;
	var inverted:Bool;
}