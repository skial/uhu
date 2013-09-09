package uhx.tem;

import haxe.rtti.Meta;
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
	private static function parserExpr(type:Type, ?collection:Bool = false):Expr {
		var result = macro null;
		
		switch ( type.follow() ) {
			case TInst(t, p):
				switch( t.get().name ) {
					case 'Xml':
						/*result = collection 
							? macro Xml.parse( child.html() ) 
							: macro Xml.parse( ele.html() );*/
						result = macro function(v:String, c:dtx.DOMNode):Xml { return Xml.parse( dtx.single.ElementManipulation.html( c ) ); }
						
					case 'String':
						result = macro function(v:String, c:dtx.DOMNode):String { return v; };
						
					case 'Array' | _ if (type.isIterable()):
						result = parserExpr( p[0], true );
						
					case _:
						#if debug
						trace( t.get().name );
						#end
				}
				
			case TAbstract(t, p):
				
				var abst = t.get();
				
				switch (abst.name) {
					case 'Bool':
						result = macro function(v:String, c:dtx.DOMNode):Bool { return (v == 'true') ? true : false; };
						
					case 'Int':
						//result = macro Std.parseInt( v );
						result = macro function(v:String, c:dtx.DOMNode):Int { return Std.parseInt( v ); };
						
					case 'Float':
						//result = macro Std.parseFloat( v );
						result = macro function(v:String, c:dtx.DOMNode):Float { return Std.parseFloat( v ); };
						
					case _ if (abst.type.isIterable()):
						result = parserExpr( p[0], true );
						
					case _:
						#if debug
						trace( abst.name );
						trace( abst.type );
						#end
						result = parserExpr( p[0], true );
				}
				
			case _:
				#if debug
				trace( type.follow() );
				#end
		};
		
		return result;
	}
	
	private static function setterExpr(ctype:ComplexType, domName:String, attName:String, attribute:Bool) {
		var nfields = ['set_single_$domName', 'set_$domName'].mkFields().mkPublic().toFFun();
		var single = nfields.get( 'set_single_$domName' );
		var mass = nfields.get( 'set_$domName' );
		var isIterable = ctype.toType().isIterable();
		var expr = attribute 
			? macro dtx.single.ElementManipulation.setAttr( children.getNode( pos ), $v { attName }, Std.string( v ) )
			: macro dtx.single.ElementManipulation.setText( children.getNode( pos ), Std.string( v ) );
		
		switch ( [attribute, isIterable] ) {
			case [false, false]:
				single.body( macro dtx.single.ElementManipulation.setText($i { domName }, '' + v) );
				
			case [true, false]:
				single.body( macro dtx.single.ElementManipulation.setAttr($i { domName }, $v { attName }, '' + v) );
				
			case [_, true]:
				mass.body( macro {
					for (i in 0...v.length) {
						$i { single.name } ( i, v[i] );
					}
				} );
				
				single.body( macro {
					var dom = $i { 'get_$domName' } ();
					var children = dtx.single.Traversing.children( dom );
					if (children.collection.length > pos) {
						$e { expr };
					} else {
						var c = new dtx.DOMCollection();
						for (i in 0...(pos-(children.collection.length-1))) {
							c.add( dtx.Tools.create( dtx.single.ElementManipulation.tagName( children.getNode() ) ) );
						}
						dom.append( null, c );
						children = dtx.single.Traversing.children( dom );
						$e { expr };
					}
				} );
				
		}
		
		if (isIterable) {
			mass.args().push( 'v'.mkArg( ctype ) );
			
			single.args().push( 'pos'.mkArg( macro: Int ) );
			single.args().push( 'v'.mkArg( ctype.asTypePath().params[0].asComplexType() ) );
		} else {
			single.args().push( 'v'.mkArg( ctype ) );
			nfields.remove( mass );
		}
		
		for (nf in nfields) {
			fields.push( nf );
		}
	}
	
	private static function mkParseField(name:String, ctype:ComplexType):Field {
		var expr = if (ctype.toType().isIterable()) {
			macro {
				return $e { Context.parse('Tem.${TemCommon.ParseCollection.name}', Context.currentPos()) } (name, ele, attr, $e { parserExpr( ctype.toType() ) } );
			};
		} else {
			macro {
				return $e { Context.parse('Tem.${TemCommon.ParseSingle.name}', Context.currentPos()) } (name, ele, attr, $e { parserExpr( ctype.toType() ) } );
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
			
			switch (field.kind) {
				case FVar(t, e):
					
					var type = t.toType();
					
					if (type.isIterable()) {
						
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
													//[ Context.parse( 'untyped ethis.set_single_$domName(key, value)', Context.currentPos() ) ]
													[ Context.parse( 'untyped std.Tem.setCollectionIndividual(value, key, ethis.get_$domName(), ${attribute?attName:null})', Context.currentPos() ) ]
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
					
					fields.push( field.mkSetter( macro { 
						$i { name } = v; 
						//$i { 'set_' + (!field.typeof().isIterable() ? 'single_' : '') + '$domName' } ( v ); 
						$e { Context.parse('Tem.set' + (field.typeof().isIterable() ? 'Collection' : 'Individual'), Context.currentPos()) } ( v, $i { domName }, $v { attribute? attName :null } );
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
					
					//setterExpr(t, domName, attName, attribute);
					
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