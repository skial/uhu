package uhx.macro.help;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using uhu.macro.Jumla;
using haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class TemCommon {
	
	public static var PreviousTem:String = 'Tem';
	public static var TemPlateExprs:Array<Expr> = [];
	public static var TemPlateFields:Array<Field> = [];
	public static var TemPlateCache:Map<String, Expr> = new Map<String, Expr>();
	
	public static var TemDOM(get, never):Field;
	
	private static function get_TemDOM():Field {
		return {
			name: 'TemDOM',
			access: [APublic],
			kind: FVar( macro: dtx.DOMCollection, macro null ),
			pos: Context.currentPos(),
		};
	}
	
	public static var TemSetup(get, never):Field;
	
	private static function get_TemSetup():Field {
		return {
			name: 'TemSetup',
			access: [APrivate],
			kind: FFun( {
				args: [ {
					name: 'fragment',
					opt: false,
					type: macro: dtx.DOMCollection
				} ],
				ret: macro: Void,
				params: [],
				expr: macro {
					$i { TemCommon.TemDOM.name } = fragment;
					uhx.tem.Parser.cls = $i { Context.getLocalClass().get().name };
					uhx.tem.Parser.instance = this;
					uhx.tem.Parser.fields = std.Type.getInstanceFields( uhx.tem.Parser.cls );
					uhx.tem.Parser.process( fragment, $v { Context.getLocalClass().get().name } );
				}
			} ),
			pos: Context.currentPos(),
		};
	}
	
	public static var TemEThis(get, never):Field;
	
	private static function get_TemEThis():Field {
		return {
			name: 'ethis',
			access: [APublic],
			kind: FVar( null ),
			pos: Context.currentPos(),
		};
	}
	
	public static var tem(get, never):TypeDefinition;
	
	private static function get_tem():TypeDefinition {
		return {
			pack: [],
			name: 'Tem' + Date.now().getTime(),
			pos: Context.currentPos(),
			meta: [ { name: ':native', params: [macro 'Tem'], pos: Context.currentPos() } ],
			params: [],
			isExtern: false,
			kind: TDClass(),
			fields: []
		}
	}
	
	public static var plate(get, never):Field;
	
	private static function get_plate():Field {
		return {
			name: 'plate',
			access: [APublic, AStatic],
			kind: FFun( {
				args: [],
				ret: macro: Void,
				expr: macro {
					
				},
				params: [],
			} ),
			pos: Context.currentPos()
		};
	}
	
	public static var arrayWrapperCounter:Int = 0;
	public static var arrayWrapper(get, never):TypeDefinition;
	
	private static function get_arrayWrapper():TypeDefinition {
		var name = 'TemArray' + arrayWrapperCounter;
		arrayWrapperCounter++;
		
		var fields = [
			'new', 'get_length', 'concat', 'copy', 'filter', 'insert', 'iterator', 'join',
			'map', 'pop', 'push', 'remove', 'reverse', 'shift', 'slice', 'sort',
			'splice', 'toString', 'unshift', 'toArray', 'arrayRead', 'arrayWrite',
			'fromArray',
		].mkFields().mkPublic().mkInline().toFFun();
		
		fields.get( 'new' )
			.body( macro { this = a; } )
			.args().push( 'a'.mkArg( macro: Array<T>, false ) );
		
		fields.push( 'length'.mkField().toFProp( 'get', 'never', macro: Int ) );
		fields.get( 'get_length' )
			.body( macro { return this.length; } );
			
		fields.get( 'concat' )
			.body( macro { return this.concat( a.toArray() ); } )
			.ret( macro: $name<T> )
			.args().push( 'a'.mkArg( macro: $name<T>, false ) );
		
		fields.get( 'copy' )
			.body( macro { return this.copy(); } )
			.ret( macro: $name<T> );
			
		fields.get( 'filter' )
			.body( macro { return this.filter( f ); } )
			.ret( macro: $name<T> )
			.args().push( 'f'.mkArg( macro: T->Bool, false ) );
		
		var _insert:Field = fields.get( 'insert' )
			.body( macro { return this.insert( pos, x ); } ).ret( macro: Void );
		_insert.args().push( 'pos'.mkArg( macro: Int, false ) );
		_insert.args().push( 'x'.mkArg( macro: T, false ) );
		
		fields.get( 'iterator' )
			.body( macro { return this.iterator(); } )
			.ret( macro: Iterator<T> );
			
		fields.get( 'join' )
			.body( macro { return this.join( sep ); } )
			.ret( macro: String )
			.args().push( 'sep'.mkArg( macro: String, false ) );
		
		fields.get( 'map' )
			.param( 'S' )
			.body( macro { return this.map( f ); } )
			.ret( macro: $name<S> )
			.args().push( 'f'.mkArg( macro: T->S, false ) );
		
		fields.get( 'pop' )
			.body( macro { return this.pop(); } )
			.ret( macro: Null<T> );
		
		fields.get( 'push' )
			.body( macro { return this.push( x ); } )
			.ret( macro: Int )
			.args().push( 'x'.mkArg( macro: T, false ) );
		
		fields.get( 'remove' )
			.body( macro { return this.remove( x ); } )
			.ret( macro: Bool )
			.args().push( 'x'.mkArg( macro: T, false ) );
		
		fields.get( 'reverse' )
			.body( macro { return this.reverse(); } )
			.ret( macro: Void );
		
		fields.get( 'shift' )
			.body( macro { return this.shift(); } )
			.ret( macro: Null<T> );
		
		var _slice:Field = fields.get( 'slice' )
			.body( macro { return this.slice( pos, end ); } ).ret( macro: $name<T> );
		_slice.args().push( 'pos'.mkArg( macro: Int, false ) );
		_slice.args().push( 'end'.mkArg( macro: Int, false ) );
		
		fields.get( 'sort' )
			.body( macro { return this.sort( f ); } )
			.ret( macro: Void )
			.args().push( 'f'.mkArg( macro: T->T->Int, false ) );
		
		var _splice:Field = fields.get( 'splice' )
			.body( macro { return this.splice( pos, len ); } ).ret( macro: $name<T> );
		_splice.args().push( 'pos'.mkArg( macro: Int, false ) );
		_splice.args().push( 'len'.mkArg( macro: Int, false ) );
		
		fields.get( 'toString' )
			.body( macro { return this.toString(); } )
			.ret( macro: String );
		
		fields.get( 'unshift' )
			.body( macro { return this.unshift( x ); } )
			.ret( macro: Void )
			.args().push( 'x'.mkArg( macro: T, false ) );
		
		fields.get( 'toArray' )
			.body( macro { return this; } )
			.ret( macro: Array<T> )
			.meta.push( ':to'.mkMeta() );
		
		var _arrayRead:Field = fields.get( 'arrayRead' )
			.body( macro { return this[key]; } ).ret( macro: T );
		_arrayRead.meta.push( ':arrayAccess'.mkMeta() );
		_arrayRead.args().push( 'key'.mkArg( macro: Int, false ) );
		
		var _arrayWrite:Field = fields.get( 'arrayWrite' )
			.body( macro { 
				return this[key] = value;
			} )
			.ret( macro: T );
		_arrayWrite.meta.push( ':arrayAccess'.mkMeta() );
		_arrayWrite.args().push( 'key'.mkArg( macro: Int, false ) );
		_arrayWrite.args().push( 'value'.mkArg( macro: T, false ) );
		
		var _fromArray:Field = fields.get( 'fromArray' ).mkStatic()
			.body( macro { return new $name( a ); } ).ret( macro: $name<T> );
		_fromArray.meta.push( ':from'.mkMeta() );
		_fromArray.args().push( 'a'.mkArg( macro: Array<T>, false ) );
		
		var td = {
			name: name,
			pack: ['uhx', 'macro', 'help'],
			meta: [],
			isExtern: false,
			kind: TDAbstract( macro: Array<T> ),
			params: [ { name: 'T', constraints: [], params: [] } ],
			pos: Context.currentPos(),
			fields: fields,
		}
		
		return td;
	}
	
}