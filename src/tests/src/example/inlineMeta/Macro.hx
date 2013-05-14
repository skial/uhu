package example.inlineMeta;

import haxe.ds.StringMap;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Format;
import haxe.macro.Printer;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.TypeTools;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class Macro {
	
	public static var cls:ClassType = null;
	public static var fields:Array<Field> = [];

	public static function build() {
		cls = Context.getLocalClass().get();
		fields = Context.getBuildFields();
		
		for (field in fields) {
			
			switch (field.kind) {
				case FFun(method):
					if (method.expr != null) {
						
						method.expr = loop( method.expr );
						
					}
					
				case _:
			}
			
		}
		
		return fields;
	}
	
	public static function loop(e:Expr, ?body:Array<Expr>) {
		var pos = e.pos;
		var result = e;
		var printer = new Printer();
		
		switch(e.expr) {
			case EMeta(s, e):
				if (s.name == ':wait' && s.params.length > 0) {
					
					result = loop( modify( e , s.params, body ) );
					
				} else if (s.name == ':wait') {
					trace( e );
				}
				
			case EBlock(exprs):
				
				var i = 0;
				
				for (expr in exprs) {
					++i;
					result = loop( expr, exprs.slice( i ) );
					
					if ( printer.printExpr( result ) != printer.printExpr( expr ) ) {
						break;
					}
					
				}
				
				if ( printer.printExpr( result ) != printer.printExpr( e ) ) {
					exprs = exprs.slice(0, i);
					
					result = { expr:EBlock(exprs), pos:pos };
					
				}
				
			case ECall(e, p):
				var params:Array<Expr> = [];
				
				for (pp in p) {
					params.push( loop( pp ) );
				}
				
				result = { expr:ECall( loop( e ), params ), pos:pos };
				
			case EFunction(n, f):
				//trace( printer.printExpr( f.expr ) );
				f.expr = loop( f.expr );
				//trace( printer.printExpr( f.expr ) );
			case _:
				//trace( e );
		}
		
		return result;
	}
	
	private static var cache:StringMap<String> = new StringMap<String>();
	
	public static function modify(e:Expr, params:Array<Expr>, body:Array<Expr>) {
		var pos = e.pos;
		var result = e;
		var printer = new Printer();
		
		switch (e.expr) {
			case ECall(e, p):
				
				find( printer.printExpr( e ) );
				
				for (pair in pairs( params )) {
					
					var method = Context.parse('function(${printer.printExpr( pair[0] )}, ${printer.printExpr( pair[1] )}) {}', e.pos);
					method = modify( method, [], body );
					
					p.push( method );
					
				}
				
				result = { expr:ECall(e, p), pos:pos };
				
			case EFunction(n, f):
				f.expr = { expr:EBlock( body ), pos:f.expr.pos };
				
				result = { expr:EFunction(n, f), pos:pos };
				
			case _:
				
		}
		
		return result;
	}
	
	private static function pairs(params:Array<Expr>):Array<Array<Expr>> {
		var result:Array<Array<Expr>> = [];
		var pair:Array<Expr> = [];
		var copy = params.copy();
		
		while (copy.length > 0) {
			
			pair = [copy.shift(), copy.shift()];
			
			for (i in 0...pair.length) {
				
				if (pair[i] == null) pair[i] = macro _;
				
			}
			
			result.push( pair );
			
		}
		
		return result;
		
	}
	
	private static function find(path:String) {
		
		var parts = path.split( '.' );
		var calls = [];
		
		while (true) {
			
			//trace(parts);
			var name = parts.pop();
			//trace(parts);
			if (parts.length == 0 && fields.exists( name )) {
				
				calls.push( name );
				parts = cls.pack;
				name = cls.name;
				
			}
			
			try {
				
				var tpath = TPath( { pack: parts, name: name, params: [], sub: null } );
				if (calls.length > 1) calls.reverse();
				
				var type = ComplexTypeTools.toType( tpath );
				
				trace( type );
				trace( calls );
				
				trace( follow( type, calls ) );
				
				break;
				
			} catch (e:Dynamic) {
				
				calls.push( name );
				
			}
			
		}
		
	}
	
	private static function follow(type:Type, path:Array<String>) {
		var result = null;
		
		while (path.length != 0) {
			var id = path.shift();
			
			switch( type ) {
				case TInst(t, _):
					var _cls = t.get();
					var _isStatic = false;
					var _field = null;
					
					if (_cls.statics.get().exists( id )) {
						_field = _cls.statics.get().get( id );
					} else if (_cls.fields.get().exists( id )) {
						_field = _cls.fields.get().get( id );
					}
					
					if (_field != null) {
						
						type = _field.type;
						result = _field;
						
					}
					
				case _:
			}
			
		}
		
		return result;
	}
	
}