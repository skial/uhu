package uhx.macro.jumla.a;

import haxe.macro.Type;
import haxe.macro.Expr;
import uhx.macro.jumla.a.AClassType;

using Lambda;
using uhx.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
abstract AClassType(ClassType) from ClassType to ClassType to BaseType {
	
	public var ancestors(get, never):ManyClassTypes;
	
	// ++ internal
	
	private function get_ancestors():ManyClassTypes {
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
	
	@:noCompletion public var original(get, never):ClassType;
	
	private function get_original():ClassType return this;
	
	// -- internal
	
}

abstract ManyClassTypes(Array<AClassType>) from Array<AClassType> to Array<AClassType> {
	
	public var filter(get, never):FilterBy<Array<AClassType>>;
	//public var fmeta(get, never):FilterMeta;
	public var meta(get, never):Array<Metadata>;
	
	// ++ internal
	
	private function get_filter():FilterBy<Array<AClassType>> return this;
	//private function get_fmeta():FilterMeta return this;
	private function get_meta():Array<Metadata> return [for ( c in this ) c.meta.original.get()];
	
	// -- interanl
	
}

private abstract FilterMeta(Array<AClassType>) from Array<AClassType> {
	
	public function get(key:String):Array<AClassType> return this.filter( function(c) return c.meta.exists( key ) ).array();
	
}