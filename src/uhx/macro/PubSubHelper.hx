package uhx.macro;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.ds.StringMap;
import haxe.macro.Context;

/**
 * ...
 * @author Skial Bainn
 */
class PubSubHelper {
	
	public static function current(ctype:ComplexType = null):Field {
		return {
			name: 'UhxCurrentInstance',
			access: [APrivate, AStatic],
			kind: FVar(macro:$ctype),
			pos: Context.currentPos(),
		};
	}
	
	public static var counter:Field = {
		name: 'UhxInstaceCounter',
		access: [APrivate, AStatic],
		kind: FVar(macro:Int, macro 0),
		pos: Context.currentPos(),
	}
	
	public static var value:Field = {
		name: 'UhxInstanceValue',
		access: [APrivate],
		kind: FVar(macro:Int),
		pos: Context.currentPos(),
	}
	
	public static var signalMap:Field = {
		name: 'UhxSignalMap',
		access: [APublic, AStatic],
		kind: FVar(macro:haxe.ds.StringMap<thx.react.Signal.Signal1<Dynamic>>),
		pos: Context.currentPos()
	};
	
	public static function signalSetup():Field {
		return {
			name: 'UhxSignalSetup',
			access: [APublic],
			kind: FFun( {
				args: [	{
					name: 'val',
					opt: false,
					type: macro: Int,
				},{
					name: 'map',
					opt: false,
					type: macro: haxe.ds.StringMap<thx.react.Signal.Signal1<Dynamic>>,
				} ],
				ret: null,
				params: [],
				expr: macro {
					
				},
			} ),
			pos: Context.currentPos()
		}
	}

	public static function _init():Field {
		return {
			pos: Context.currentPos(),
			name: '__init__',
			access: [APublic, AStatic],
			kind: FFun( {
				args: [],
				ret: null,
				expr: macro { },
				params: []
			} )
		};
	}
	
}