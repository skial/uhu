package uhu.mu.t;

/**
 * ...
 * @author Skial Bainn
 */

//open:String, content:String, close:String, pos:TPosition
@:hocco
typedef TPartial = {
	var otag:String;
	var content:String;
	var ctag:String;
	var parsed:TParser;
}