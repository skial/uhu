package uhu.mu.e;

import uhu.mu.t.TParser;
import uhu.mu.Common;

/**
 * ...
 * @author Skial Bainn
 */

@:hocco
enum ETag {
	//	static text
	Static(content:String);
	
	Normal(content:String);
	//	open &
	//	open { close }
	Unescape(content:String);
	
	//	open : # close : /
	//	open : ^ close : /
	Section(content:String, opening:Bool, tokens:Array<ETag>, template:String, inverted:Bool);
	
	//	open : !
	Comments(content:String);
	
	//	open : >
	Partials(content:String, parsed:Void->Null<TParser>);
	
	//	open : = close : =
	Delimiter(content:String);
}