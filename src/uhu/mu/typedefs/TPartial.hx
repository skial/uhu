package uhu.mu.typedefs;

/**
 * ...
 * @author Skial Bainn
 */

//open:String, content:String, close:String, pos:TPosition
typedef TPartial = {
	var otag:String;
	var content:String;
	var ctag:String;
	var parsed:TParser;
}