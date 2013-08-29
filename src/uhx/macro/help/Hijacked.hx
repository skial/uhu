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
class Hijacked {
	
	private static var counter:Int = 0;
	private static var pack:Array<String> = ['uhx', 'macro', 'help'];

	public static var array(get, never):TypeDefinition;
	private static function get_array():TypeDefinition {
		var name = 'HijackedArray${counter}';
		counter++;
		
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
			pack: pack,
			meta: [],
			isExtern: false,
			kind: TDAbstract( macro: Array<T> ),
			params: [ { name: 'T', constraints: [], params: [] } ],
			pos: Context.currentPos(),
			fields: fields,
		}
		
		return td;
	}
	
	public static var string(get, never):TypeDefinition;
	private static function get_string():TypeDefinition {
		var name = 'HijackedString${counter}';
		var ctype = TPath( {
			pack: pack,
			name: name,
			params: [],
		} );
		counter++;
		
		var fields:Array<Field> = [
			'new', 'length', 'get_length', 'toUpperCase', 'toLowerCase', 'charAt', 'charCodeAt',
			'indexOf', 'lastIndexOf', 'split', 'substr', 'substring', 'toString',
			'fromString', /*'fromCharCode',*/
		].mkFields().mkInline().mkPublic().toFFun();
		
		for (field in fields) {
			
			switch(field.name) {
				case 'new':
					field.body( macro this = s );
					field.args().push( 's'.mkArg( macro: String ) );
					
				case 'length': field.toFProp( 'get', 'never', macro: Int );
				case 'get_length': field.body( macro return this.length );
				case 'toUpperCase': field.body( macro return new $name( this.toUpperCase() ) ).ret( macro: $ctype );
				case 'toLowerCase': field.body( macro return new $name( this.toLowerCase() ) ).ret( macro: $ctype );
				case 'charAt': field.body( macro return new $name( this.charAt(index) ) ).ret( macro: $ctype ).args().push( 'index'.mkArg( macro: Int ) );
				case 'charCodeAt': field.body( macro return this.charCodeAt(index) ).ret( macro: Null<Int> ).args().push( 'index'.mkArg( macro: Int ) );
				case 'indexOf': 
					field.body( macro return this.indexOf(string, startIndex) ).ret( macro: Int );
					field.args().push( 'str'.mkArg( macro: String ) );
					field.args().push( 'startIndex'.mkArg( macro: Int, true ) );
					
				case 'lastIndexOf':
					field.body( macro return this.lastIndexOf(string, startIndex) ).ret( macro: Int );
					field.args().push( 'str'.mkArg( macro: String ) );
					field.args().push( 'startIndex'.mkArg( macro: Int, true ) );
					
				case 'split': field.body( macro return this.split(delimiter) ).ret( macro: Array < $ctype > ).args().push( 'delimiter'.mkArg( macro: String ) );
				case 'substr': 
					field.body( macro return new $name( this.substr(pos, len) ) ).ret( macro: $ctype );
					field.args().push( 'pos'.mkArg( macro: Int ) );
					field.args().push( 'len'.mkArg( macro: Int, true ) );
					
				case 'substring': 
					field.body( macro return new $name( this.substring(startIndex, endIndex) ) ).ret( macro: $ctype );
					field.args().push( 'startIndex'.mkArg( macro: Int ) );
					field.args().push( 'endIndex'.mkArg( macro: Int, true ) );
					
				case 'toString': field.body( macro return this.toString() ).ret( macro: String ).meta.push( ':to'.mkMeta() );
				case 'fromString': 
					field.mkStatic().body( macro return new $name( s ) ).ret( macro: $ctype );
					field.args().push( 's'.mkArg( macro: String ) );
					field.meta.push( ':from'.mkMeta() );
			}
			
		}
		
		return {
			name: name,
			pack: pack,
			meta: [],
			isExtern: false,
			kind: TDAbstract( macro: String, [], [macro: String] ),
			params: [],
			pos: Context.currentPos(),
			fields: fields,
		}
	}
}