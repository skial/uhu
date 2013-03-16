package ;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.unit.TestRunner;
import uhu.macro.jumla.TypeToolsSpecs;

/**
 * ...
 * @author Skial Bainn
 */
class MacroTests {

	public static function run():Array<Field> {
		
		var runner = new TestRunner();
		
		runner.add( new TypeToolsSpecs() );
		
		runner.run();
		
		return Context.getBuildFields();
		
	}
	
}