package ;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.unit.TestRunner;
import uhu.macro.jumla.type.TypePrinterSpecs;

//import uhu.macro.jumla.TypeToolsSpecs;
//import uhu.hocco.HoccoSpecs;

/**
 * ...
 * @author Skial Bainn
 */
class MacroTests {

	public static function run():Array<Field> {
		
		var runner = new TestRunner();
		
		//runner.add( new TypePrinterSpecs() );
		//runner.add( new TypeToolsSpecs() );
		//runner.add( new HoccoSpecs() );
		
		runner.run();
		
		return Context.getBuildFields();
		
	}
	
}