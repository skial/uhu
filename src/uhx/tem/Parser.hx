package uhx.tem;

import haxe.rtti.Meta;
import uhx.tem.help.TemHelp;
#if macro
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import uhx.macro.help.Hijacked;
import uhx.macro.help.TemCommon;
import haxe.macro.ComplexTypeTools;
#end

using Xml;
using Detox;
using Lambda;
using StringTools;
#if macro
using uhu.macro.Jumla;
using haxe.macro.Context;
#end

typedef Fields = #if macro Array<Field> #else Array<String> #end;

/**
 * ...
 * @author Skial Bainn
 */
class Parser {
	
	public static var current:String = null;
	public static var fields:Fields = null;
	public static var cls: #if macro ClassType #else Class<Dynamic> #end;
	
	#if js
	public static var instance:Dynamic = null;
	#end

	public static function process(html:DOMCollection, name:String, child:Bool = false) {
		var invalid = ['class', 'id'];
		
		for (ele in html) {
			
			#if macro
			if (!child) {
				
				var local = Context.getLocalClass().get();
				var ttype = local.path().getType().follow();
				var ctype = ttype.toComplexType();
				
				TemCommon.TemPlateExprs.push( { expr: ENew( std.Type.enumParameters(ctype)[0], [ macro @:fragment Detox.find( $v { '.' + name } ) ] ), pos: cls.pos } );
			}
			#end
			
			for (attr in ele.attributes#if macro () #end) {
				
				var _attr = 
				#if macro 
				attr;
				#else 
				attr.nodeName;
				#end
				
				var isData = _attr.startsWith('data-');
				
				switch (_attr) {
					case _ if (isData && invalid.indexOf( _attr ) == -1):
						processEle( _attr.replace('data-', '').replace('-', '_'), ele );
						
					case _ if (!isData && invalid.indexOf( _attr ) == -1):
						processAttr( _attr.replace('-', '_'), ele );
						
					case _:
				}
				
			}
			
			if (ele.attr('class') != '' && !ele.hasClass(name)) continue;
			
			if (ele.children( true ).length > 0) {
				
				process( ele.children( true ), name, true );
				
			}
			
		}
		
		return html;
	}
	
	#if macro
	private static function setterExpr(type:Type):Expr {
		var pos = Context.currentPos();
		var result:Expr = Context.parse( 'uhx.tem.help.TemHelp.toDefault', pos );
		
		switch ( type.follow() ) {
			case TInst(t, p):
				switch( t.get().name ) {
					case 'Array' | _ if (type.isIterable() && p[0] != null):
						result = setterExpr( p[0] );
					
					case _ if (TemHelp.toMap.exists( t.get().name )):
						result = Context.parse( 'uhx.tem.help.TemHelp.to${t.get().name}', pos );
						
					case _:
						
				}
				
			case TAbstract(t, p):
				var abst = t.get();
				
				switch (abst.name) {
					case _ if (abst.type.isIterable() && p[0] != null):
						result = setterExpr( p[0] );
					
					case _ if (TemHelp.toMap.exists( abst.name )):
						result = Context.parse( 'uhx.tem.help.TemHelp.to${abst.name}', pos );
						
					case _:
						
				}
				
			case _:
				#if debug
				trace( type.follow() );
				#end
		};
		
		return result;
	}
	
	private static function parserExpr(type:Type, ?collection:Bool = false):Expr {
		var pos = Context.currentPos();
		var result = macro null;
		
		switch ( type.follow() ) {
			case TInst(t, p):
				switch( t.get().name ) {
					case 'Array' | _ if (type.isIterable()):
						result = parserExpr( p[0], true );
						
					case _ if (TemHelp.parserMap.exists( t.get().name )):
						result = Context.parse( 'uhx.tem.help.TemHelp.parse${t.get().name}', pos );
						
					case _:
						result = Context.parse( 'uhx.tem.help.TemHelp.find("${t.get().name}")', pos );
						#if debug
						trace( t.get().name );
						#end
				}
				
			case TAbstract(t, p):
				var abst = t.get();
				
				switch (abst.name) {
					case _ if (abst.type.isIterable() && p[0] != null):
						result = parserExpr( p[0], true );
						
					case _ if (TemHelp.parserMap.exists( abst.name )):
						result = Context.parse( 'uhx.tem.help.TemHelp.parse${abst.name}', pos );
						
					case _:
						result = Context.parse( 'uhx.tem.help.TemHelp.find("${t.get().name}")', pos );
						#if debug
						trace( abst.name );
						trace( abst.type );
						#end
				}
				
			case _:
				#if debug
				trace( type.follow() );
				#end
		};
		
		return result;
	}
	
	private static function mkParseField(name:String, ctype:ComplexType):Field {
		var expr = if (ctype.toType().isIterable()) {
			macro {
				return $e { Context.parse('uhx.tem.help.TemHelp.parseCollection', Context.currentPos()) } (name, ele, attr, $e { parserExpr( ctype.toType() ) } );
			};
		} else {
			macro {
				return $e { Context.parse('uhx.tem.help.TemHelp.parseSingle', Context.currentPos()) } (name, ele, attr, $e { parserExpr( ctype.toType() ) } );
			};
		}
		
		var source = 'parse$name'.mkField()
			.mkPrivate().mkStatic()
			.toFFun().body( expr );
			
		source.args().push( 'name'.mkArg( macro: String, false ) );
		source.args().push( 'ele'.mkArg( macro: dtx.DOMNode, false ) );
		source.args().push( 'attr'.mkArg( macro: Bool, false ) );
		
		return source;
	}
	
	public static function processDOM(name:String, ele:DOMNode, attribute:Bool = false) {
		
		if (fields.exists( name )) {
			var field = fields.get( name );
			var prefix = attribute ? 'TEMATTR' : 'TEMDOM';
			var domName = '${prefix}_$name';
			var attName = (attribute?'':'data-') + name;
			var pos = Context.currentPos();
			
			switch (field.kind) {
				case FVar(t, e):
					
					var type = t.toType();
					
					if (type.isIterable()) {
						field.meta.push( 'isIterable'.mkMeta() );
						switch ( type ) {
							case TInst(_t, _p):
								
								switch (_t.get().name) {
									case 'Array':
										var td:TypeDefinition = Hijacked.array;
										var aw:Field = td.fields.get( 'arrayWrite' );
										var m:Function = aw.getMethod();
										
										switch (m.expr.expr) {
											case EBlock( es ):
												m.expr = { expr: EBlock( 
													// dirty little trick, in every non static method, add `var ethis = this`
													// so when `arrayWrite` gets inlined it references the correct instance.
													// ^ This is done in by EThis.hx as part of uhx.macro.klas.Handler.hx ^
													[ macro $e { Context.parse( 'untyped uhx.tem.help.TemHelp.setCollectionIndividual(value, key, ethis.get_$domName(), ${setterExpr( t.toType() ).printExpr()}, ${attribute?attName:null})', pos ) } ]
													.concat( es ) 
												), pos: aw.pos };
												
											case _:
										}
										
										Context.defineType( td );
										
										t = TPath( {
											pack: td.pack,
											name: td.name,
											params: [ TPType( _p[0].toComplexType() ) ],
										} );
										
									case _:
										
								}
								
							case _:
								
						}
						
					}
					
					field.toFProp('default', 'set', t, e);
					
					fields.push( mkParseField( name, t ) );
					
					var call = Context.parse('uhx.tem.help.TemHelp.set' + (field.typeof().isIterable() ? 'Collection' : 'Individual'), pos);
					fields.push( field.mkSetter( macro { 
						$i { name } = v; 
						$call( v, $i { domName }, $e{ setterExpr( t.toType() ) }, $v { attribute? attName :null } );
						return v; } 
					) );
					
					fields.push( 
						domName.mkField()
						.mkPublic()
						.toFProp( 'get', 'null', macro: dtx.DOMNode )
						.addMeta( ':isVar'.mkMeta() )
					);
					
					fields.push( fields.get( domName ).mkGetter( macro {
						if ($i { domName } == null) {
							$i { domName } = dtx.collection.Traversing.find($i { TemCommon.TemDOM.name }, '[$attName]').getNode();
						}
						return $i { domName };
					} ) );
					
				case _:
					
			}
			
		}
		
	}
	
	public static inline function processEle(name:String, ele:DOMNode) {
		processDOM( name, ele );
	}
	
	public static inline function processAttr(name:String, ele:DOMNode) {
		processDOM( name, ele, true );
	}
	#else
	public static function processDOM(name:String, ele:DOMNode, attribute:Bool = false) {
		
		if (fields.indexOf( name ) > -1) {
			
			var hasSetter = fields.indexOf( 'set_$name' ) > -1;
			//var hasGetter = fields.indexOf( 'get_$name' ) > -1;
			
			if (hasSetter) {
				
				var value:String = attribute ? ele.attr( name ) : ele.text();
				//var result:Dynamic = Reflect.field(cls, 'parse$name')( value );
				var result:Dynamic = Reflect.field(cls, 'parse$name')( name, ele, attribute );
				
				Reflect.setField(instance, name, result);	// will likely need to add a boolean for setters to check
				//Reflect.setProperty(instance, name, result);
				
			}
			
		}
		
	}
	
	public static inline function processEle(name:String, ele:DOMNode) {
		processDOM( name, ele );
	}
	
	public static inline function processAttr(name:String, ele:DOMNode) {
		processDOM( name, ele, true );
	}
	#end
	
}