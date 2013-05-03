package example.printTypeDefinition;

import haxe.macro.Printer;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class Macro {

	public static function build() {
		var td:TypeDefinition = {
			name:'Test100',
			pack:[],
			pos:Context.currentPos(),
			meta:[],
			params:[],
			isExtern:false,
			kind: TDClass(),
			fields: [ {
				name:'new',
				doc:null,
				access:[APublic],
				kind:FFun( {
					args:[],
					ret:macro:Void,
					expr:macro {},
					params:[]
				} ),
				pos:Context.currentPos(),
				meta:[]
			} ]
			
		}
		
		trace( new Printer().printTypeDefinition( td ) );
		
		return Context.getBuildFields();
	}
	
}