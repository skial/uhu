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
	
	public static var ParseElement(get, never):Field;
	
	private static function get_ParseElement():Field {
		var field = 'parseElement'.mkField().mkPublic()
			.mkStatic().toFFun()
			.body( macro {
				var v:String = attr ? dtx.single.ElementManipulation.attr( ele, name ) : dtx.single.ElementManipulation.text( ele );
				return parse( v, ele );
			} ).param( 'T' ).ret( macro: T );
		
		field.args().push( 'name'.mkArg( macro: String ) );
		field.args().push( 'ele'.mkArg( macro: dtx.DOMNode ) );
		field.args().push( 'attr'.mkArg( macro: Bool ) );
		field.args().push( 'parse'.mkArg( macro: String->dtx.DOMNode->T ) );
		
		return field;
	}
	
	public static var ParseCollection(get, never):Field;
	
	private static function get_ParseCollection():Field {
		var field = 'parseCollection'.mkField().mkPublic()
			.mkStatic().toFFun()
			.body( macro {
				var r:Array<T> = [];
				var v:String = '';
				for (child in dtx.single.Traversing.children( ele, true )) {
					v = attr ? dtx.single.ElementManipulation.attr( child, name ) : dtx.single.ElementManipulation.text( child );
					r.push( parse( v, child ) );
				}
				return r;
			} ).param( 'T' ).ret( macro: Array<T> );
		
		field.args().push( 'name'.mkArg( macro: String ) );
		field.args().push( 'ele'.mkArg( macro: dtx.DOMNode ) );
		field.args().push( 'attr'.mkArg( macro: Bool ) );
		field.args().push( 'parse'.mkArg( macro: String->dtx.DOMNode->T ) );
		
		return field;
	}
	
}