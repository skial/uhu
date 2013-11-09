package uhx.macro.jumla.a;

/**
 * ...
 * @author Skial Bainn
 */
abstract MetaEntry(haxe.macro.Expr.MetadataEntry) from haxe.macro.Expr.MetadataEntry to haxe.macro.Expr.MetadataEntry {

	public var name(get, set):String;
	
	public function new(me:haxe.macro.Expr.MetadataEntry) {
		this = me;
	}
	
	private function get_name():String return this.name;
	private function set_name(v:String):String return this.name = v;
	
}