package uhx.macro.jumla.a;

import haxe.macro.Type;

/**
 * ...
 * @author Skial Bainn
 */
abstract AClassType(ClassType) from ClassType to ClassType to BaseType {
	
	public var ancestors(get, never):Array<AClassType>;
	
	// ++ internal
	
	private function get_ancestors():Array<AClassType> {
		var result:Array<AClassType> = [];
		var cls = this;
		
		while (cls.superClass != null) {
			result.push( cls = cls.superClass.t.get() );
		}
		
		return result;
	}
	
	// ++ from ABaseType
	
	public var doc(get, never):String;
	public var name(get, never):String;
	public var pack(get, never):Array<String>;
	public var path(get, never):String;
	public var meta(get, set):AMetaAccess;
	
	private function get_doc():String return this.doc == null ? '' : this.doc;
	private function get_name():String return this.name;
	private function get_pack():Array<String> return this.pack;
	private function get_path():String return this.pack.concat([this.name]).join('.');
	private function get_meta():AMetaAccess return this.meta;
	
	private function set_meta(v:MetaAccess):AMetaAccess {
		for (m in this.meta.get()) this.meta.remove( m.name );
		for (m in v.get()) this.meta.add( m.name, m.params, m.pos );
		return v;
	}
	
	// -- from ABaseType
	
	// -- internal
	
}