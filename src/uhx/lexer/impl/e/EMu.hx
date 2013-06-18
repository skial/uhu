package uhx.lexer.impl.e;

/**
 * ...
 * @author Skial Bainn
 */
enum EMu {
	// Anything
	Static(v:String);
	
	// [a-zA-Z0-9. ]
	Normal(v:String);
	
	// & or {
	Unescaped(v:String);
	
	// #
	Section(v:String, truthy:Bool, tokens:Array<EMu>);
	
	// !
	Comment(v:String);
	
	// =
	Delimiter(v:String, otag:String, ctag:String);
	
	// >
	Partial(v:String, tokens:Array<EMu>);
	
	// Marks the end of a section
	Close(v:String);
	
	Tab(v:String);
	Space(v:String);
	Newline(v:String);
	//Carriage(v:String);
}