package uhx.macro;

import haxe.ds.Option;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using StringTools;
using uhu.macro.Jumla;

typedef TMatches = {
	var pos:Int;
	var exprs:Array<Expr>;
	var set:Expr->Void;
}

/**
 * ...
 * @author Skial Bainn
 */
class Wait {
	
	public static function build():Array<Field> {
		return handler( Context.getLocalClass().get(), Context.getBuildFields() );
	}

	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		
		if (!Context.defined( 'display' )) {
			for (field in fields) {
				
				switch (field.kind) {
					case FFun(method):
						if (method.expr != null) {
							
							original = method.expr.expr.getParameters()[0];
							method.expr = loop( method.expr );
							
						}
						
					case _:
				}
				
			}
		}
		
		return fields;
	}
	
	public static var STEP:Int = 0;
	public static var DECLARTION:Array<Expr> = [];
	public static var STATE:Option<Array<Expr>> = None;
	public static var original:Array<Expr> = [];
	
	public static function loop(e:Expr, ?body:Array<Expr>) {
		var result = e;
		
		switch(e.expr) {
			case EMeta(m, e) if (m.name.endsWith('wait')):
				
				if (m.params.length > 0) {
					STATE = Some(m.params);
				}
				
				result = loop( e, body );
				
				STATE = None;
				
			case EBlock(exprs):
				
				var index = exprs.indexOf( 'EMeta' );
				
				if (index > -1) {
					
					// Get everything inbetween each @:wait that is found.
					var chunks:Array<Array<Expr>> = exprs.split( 'EMeta' );
					
					// Remove any expressions which appears before the first @:wait
					// and store it in misfits.
					var i = 0;
					var misfits:Array<Expr> = [];
					while (i != exprs.indexOf( 'EMeta' ) && index != -1) {
						
						++i;
						var val = chunks[0].shift();
						if (val != null) misfits.push( val );
						
						if (chunks[0].length == 0) chunks.shift();
						
					}
					
					var nbody:Array<Expr> = [];
					var ecopy = exprs.copy();
					ecopy.reverse();
					
					var i = exprs.length - 1;
					for (e in ecopy) {
						
						var isMeta = e.expr.getName() == 'EMeta';
						
						STEP = i+1;
						
						if (isMeta) {
							
							var chunk = isMeta ? chunks.pop() : [];
							
							if (nbody.length > 0) {
								chunk = chunk.concat( nbody );
								nbody = [];
							}
							
							e = loop( e, (isMeta && chunk != null) ? chunk : [] );
							
							nbody = nbody.concat( DECLARTION );
							nbody.push( e );
							
							DECLARTION = [];
						}
						
						--i;
						
					}
					
					// Combine any expression before the first @:wait metadata with the newly
					// constructed method body.
					result = { expr: EBlock( misfits.concat( nbody ) ), pos: e.pos };
				}
				
			case ECall(e, oparams):
				
				// KEY
				// oparams -> original parameters
				// mparams -> metadata parameters
				
				/*var type;
				for (expr in original) {
					if (expr.printExpr().startsWith( e.printExpr().split('.')[0] )) {
						type = expr.typeof();
						break;
					}
				}*/
				var type = e.printExpr().find();
				var arity = type.arity();
				var args = type.args();
				
				var matches:Array<TMatches> = [];
				
				switch (STATE) {
					case None:
						// Look for array declerations eg. [suc]
						
						/*for (i in 0...oparams.length) {
							
							switch (oparams[i].expr) {
								case EArrayDecl(values):
									matches.push( { exprs: values, pos: i } );
									
								case _:
									
							}
							
						}*/
						
						matches = loopECallArgs( oparams );
						
						async(e, oparams, matches, body);
						
					case Some(mparams):
						// First look for wildcards eg. _
						var wildcards:Array<Int> = [];
						
						for (i in 0...oparams.length) {
							
							if (oparams[i].getConst().isWildcard()) {
								wildcards.push( i );
							}
							
						}
						
						if (wildcards.length > 0) {
							// Wildcards found
							/*for (i in 0...mparams.length) {
								
								switch (mparams[i].expr) {
									case EArrayDecl(values):
										var val = (wildcards[0] == null) ? oparams.length + i : wildcards.shift();
										matches.push( { exprs: values, pos: val } );
										
									case _:
										
								}
								
							}*/
							
							matches = loopECallArgs( mparams );
							
							async(e, oparams, matches, body);
							
						} else {
							// Just push modified mparams to end of oparams
							
							/*for (i in 0...mparams.length) {
								
								switch (mparams[i].expr) {
									case EArrayDecl(values):
										matches.push( { exprs: values, pos: oparams.length + i } );
										
									case _:
										
								}
								
							}*/
							
							matches = loopECallArgs( mparams );
							
							async(e, oparams, matches, body);
							
						}
						
				}
				
				
			case _:
				//trace( e );
		}
		
		return result;
	}
	
	private static function async(e:Expr, oparams:Array<Expr>, matches:Array<TMatches>, body:Array<Expr>) {
		// More than one method needs to be creating, but each method needs to have
		// access to each listed parameter. So they are created before the method call
		// and the values are set in the method body, which calls a newly created private
		// function.
		/*
			
			-----
			BEFORE
			-----
			@:wait js.Browser.window.requestFileSystem(0, 0, [success], [error]);
			// code, code, code
			
			-----
			AFTER
			-----
			var success, error;
			var step1 = function() {
				// code, code, code
			}
			
			js.Browser.window.requestFileSystem(0, 0, function(_success){
				success=_success;
				step1();
			}, function(_error){
				error=_error;
				step1();
			});
			
		 */
		
		var vars:Array<Var> = [];
		var otype:Type = e.printExpr().find();
		var ret:Type = null;
		
		for (match in matches) {
			
			if (match.exprs.length > 0) {
				
				var oarg = otype.args()[match.pos];
				if (oarg == null) continue;
				
				var ftype = Context.follow( oarg.t );
				
				switch (ftype) {
					case TFun(_, _ret):
						ret = _ret;
						
					case _:
				}
				
			}
			
			var args:Array<FunctionArg> = [];
			var nbody:Array<Expr> = [];
			
			for (expr in match.exprs) {
				
				var name = expr.printExpr();
				
				/*
				 * @:wait MyClass.method( [arg1, arg2], [error] );
				 * Turns `arg1`, `arg2` and `error` into `var arg1, arg2, error;`
				 */ 
				vars.push( { name: name, type: null, expr: null } );
				
				/*
				 * @:wait MyClass.method( [arg1, arg2], [error] );
				 * Creates placeholder args for generated method, prefixing with an
				 * under score.
				 */
				args.push( { name: '_$name', opt: false, type: null, value: null } );
				
				/*
				 * @:wait MyClass.method( [arg1, arg2], [error] );
				 * Creates an expression of `arg1 = _arg1;` to be put into the
				 * generated methods body.
				 */
				nbody.push( macro $i { name } = $i { '_$name' } );
				
			}
			
			nbody = nbody.concat( [macro $i { 'step$STEP' } () ] );	//	Call step#()
			if (ret != null) nbody = nbody.concat( [macro return $e { ret.defaults() } ] );	// Add a return value, if needed
			
			// Replace matched params with callback
			match.set( { 
				expr: EFunction( null, {
					args: args,
					ret: ret == null ? null : Context.toComplexType( ret ),
					params: [],
					expr: { 
						expr: EBlock( nbody ), 
						pos: e.pos 
					}
				} ), 
				pos: e.pos 
			} );
			
		}
		
		DECLARTION.push( { expr: EVars( vars ), pos: e.pos } );
		
		DECLARTION.push( { 
			expr: EVars( [ {
				name: 'step$STEP', 
				type: null, 
				expr: { 
					expr: EFunction( null, {
						args: [],
						ret: null,
						params: [],
						expr: { expr: EBlock( body ), pos: e.pos }
					} ), 
					pos: e.pos }
				} ] ),
			pos: e.pos
		} );
	}
	
	private static function loopECallArgs(args:Array<Expr>):Array<TMatches> {
		var result:Array<TMatches> = [];
		
		for (i in 0...args.length) {
			
			switch (args[i].expr) {
				case EArrayDecl(values):
					result.push( { 
						pos: i,
						exprs: values,
						set: function(nexpr:Expr) {
							args[i] = nexpr;
						}
					} );
					
				case ECall(e, params):
					var r = loopECallArgs( params );
					if (r.length > 0) {
						result.push( { 
							pos: i,
							exprs: r[0].exprs, 
							set: function(nexpr:Expr) {
								//args[i] = { expr: ECall( e, [nexpr] ), pos: args[i].pos };
								r[0].set( nexpr );
							}
						} );
					}
					
				case _:
					//trace( args[i] );
			}
			
		}
		
		return result;
	}
	
}