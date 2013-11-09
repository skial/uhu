package uhx.macro.jumla.a;

import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;
import uhu.macro.jumla.Common;

using Lambda;
//using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
abstract Meta(Metadata) from Metadata to Metadata {
	
	public function exists(name:String):Bool return Common.exists( this, name );
	
	@:arrayAccess @:noCompletion public function getInt(v:Int):MetaEntry return this[v];
	
	@:arrayAccess public function get(name:String):Truthy<MetaEntry> {
		return getInt(Common.indexOf( this, name ));
	}
	
	@:arrayAccess public function set(name:String, value:MetadataEntry):MetaEntry {
		get( name ) ? this[Common.indexOf( this, name )] = value : this.push( value );
		return value;
	}
	
	@:arrayAccess @:noCompletion public function setEmpty(name:String, value: { } ):MetaEntry {
		var v = { name:name, params:[], pos:Context.currentPos() };
		get( name ) ? this[Common.indexOf( this, name )] = v : this.push( v );
		return v;
	}
	
	@:arrayAccess @:noCompletion public function setParams(name:String, value:Array<Expr>):MetaEntry {
		var v = { name:name, params:value, pos:Context.currentPos() };
		get( name ) ? this[Common.indexOf( this, name )] = v : this.push( v );
		return v;
	}
	
}