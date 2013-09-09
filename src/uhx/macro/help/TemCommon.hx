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
	
	public static var ParseSingle(get, never):Field;
	
	private static function get_ParseSingle():Field {
		var field = 'parseSingle'.mkField().mkPublic()
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
	
	public static var SetIndividual(get, never):Field;
	
	private static function get_SetIndividual():Field {
		var field = 'setIndividual'.mkField().mkPublic()
			.mkStatic().toFFun()
			.body( macro {
				attr == null 
				? dtx.single.ElementManipulation.setText(dom, Std.string( value ))
				: dtx.single.ElementManipulation.setAttr(dom, attr, Std.string( value ));
			} ).param( 'T' );
		
		field.args().push( 'value'.mkArg( macro: T ) );
		field.args().push( 'dom'.mkArg( macro: dtx.DOMNode ) );
		field.args().push( 'attr'.mkArg( macro: String, true ) );
		return field;
	}
	
	public static var SetCollection(get, never):Field;
	
	private static function get_SetCollection():Field {
		var field = 'setCollection'.mkField().mkPublic()
			.mkStatic().toFFun()
			.body( macro {
				for (i in 0...value.length) {
					$i { SetCollectionIndividual.name } ( value[i], i, dom, attr );
				}
			} ).param( 'T' );
		
		field.args().push( 'value'.mkArg( macro: Array<T> ) );
		field.args().push( 'dom'.mkArg( macro: dtx.DOMNode ) );
		field.args().push( 'attr'.mkArg( macro: String, true ) );
		return field;
	}
	
	public static var SetCollectionIndividual(get, never):Field;
	
	private static function get_SetCollectionIndividual():Field {
		var field = 'setCollectionIndividual'.mkField().mkPublic()
			.mkStatic().toFFun()
			.body( macro {
				//var dom = getDOM();
				var children = dtx.single.Traversing.children( dom );
				if (children.collection.length > pos) {
					attr != null
						? dtx.single.ElementManipulation.setAttr( children.getNode( pos ), attr, Std.string( value ) )
						: dtx.single.ElementManipulation.setText( children.getNode( pos ), Std.string( value ) );
				} else {
					var c = new dtx.DOMCollection();
					for (i in 0...(pos-(children.collection.length-1))) {
						c.add( dtx.Tools.create( dtx.single.ElementManipulation.tagName( children.getNode() ) ) );
					}
					dtx.single.DOMManipulation.append( dom, null, c );
					children = dtx.single.Traversing.children( dom );
					attr != null 
						? dtx.single.ElementManipulation.setAttr( children.getNode( pos ), attr, Std.string( value ) )
						: dtx.single.ElementManipulation.setText( children.getNode( pos ), Std.string( value ) );
				}
			} ).param( 'T' );
		
		field.args().push( 'value'.mkArg( macro: T ) );
		field.args().push( 'pos'.mkArg( macro: Int ) );
		field.args().push( 'dom'.mkArg( macro: dtx.DOMNode ) );
		field.args().push( 'attr'.mkArg( macro: String, true ) );
		return field;
	}
	
}