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
	private static function parserExpr(type:Type):Expr {
		var result = macro null;
		var iterable = Context.getType('Iterable');
		
		switch ( type.follow() ) {
			case TInst(t, p):
				switch( t.get().name ) {
					case 'String':
						result = macro v;
						
					case 'Array' | _ if (type.unify( iterable )):
						result = parserExpr( p[0] );
						
					case _:
						#if debug
						trace( t.get().name );
						#end
				}
				
			case TAbstract(t, p):
				
				switch (t.get().name) {
					case 'Bool':
						result = macro (v == 'true') ? true : false;
						
					case 'Int':
						result = macro Std.parseInt( v );
						
					case 'Float':
						result = macro Std.parseFloat( v );
						
					case _:
						#if debug
						//trace( t.get().name );
						#end
						result = parserExpr( p[0] );
				}
				
			case _:
				
		};
		
		return result;
	}
	
	private static function mkParseField(name:String, ctype:ComplexType):Field {
		var expr = ctype.toType().isIterable() 
			? macro {
				var r = [];
				var v = '';
				for (child in dtx.single.Traversing.children( ele, true )) {
					v = attr ? dtx.single.ElementManipulation.attr( child, name ) : dtx.single.ElementManipulation.text( child );
					r.push( $e { parserExpr( ctype.toType() ) } );
				}
				return r;
			}
			: macro {
				var v = attr ? dtx.single.ElementManipulation.attr( ele, name ) : dtx.single.ElementManipulation.text( ele );
				return $e { parserExpr( ctype.toType() ) };
			};
		var source = 'parse$name'.mkField()
			.mkPrivate()
			.mkStatic()
			.toFFun()
			.body( expr );
			
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
													// so when `arrayWrite` get inlined it references the correct instance.
													[ Context.parse( 'untyped ethis.set_single_$domName(key, value)', Context.currentPos() ) ]
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
						$i { 'set_${prefix}_$name' } ( v ); 
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
					
					var id = 'set_$domName';
					
					switch ( [attribute, type.isIterable()] ) {
						case [true, false]:
							fields.push( id.mkField()
								.mkPublic()
								.toFFun()
								.body( macro dtx.single.ElementManipulation.setAttr($i { domName }, $v { attName }, '' + v) )
							);
							fields.get( id ).args().push( 'v'.mkArg( t, false ) );
							
						case [false, false]:
							fields.push( id.mkField()
								.mkPublic()
								.toFFun()
								.body( macro dtx.single.ElementManipulation.setText($i { domName }, '' + v) )
							);
							fields.get( id ).args().push( 'v'.mkArg( t, false ) );
							
						/*case [_, true]:
							var id = 'set_INDIV${prefix}_$name';
							fields.push( id.mkField()
								.mkPublic()
								.toFFun()
								.body( macro {
									var child = $i { 'get_${prefix}_$name' } .children()[ pos ];
									if (child == null ) {
										child = dtx.Tools.parse('<div></div>');
										// Need to insert a new DOM element, matching the first child's node type.
										// Probably better to create a help class to handle all of this instead of
										// relying on macro generation.
									}
									dtx.single.ElementManipulation.setAttr( child, $v { name }, '' );
								} )
							);
							fields.get( id ).args().push( 'pos'.mkArg( macro: Int, false ) );*/
							
						case [true, true]:
							fields.push( id.mkField()
								.mkPublic()
								.toFFun()
								.body( macro {
									var dom = dtx.single.Traversing.children( $i { 'get_$domName' }(), true );
									for (i in 0...v.length) {
										//var _v = v[i];
										if (dom.collection.length > i) {
											dtx.single.ElementManipulation.setAttr( dom.getNode( i ), $v{ attName }, '' + v[i] );
										} else {
											dom.add( dtx.single.ElementManipulation.setAttr( dtx.Tools.create( 'div' ), $v{ attName }, '' + v[i] ), i );
										}
									}
								} )
							);
							fields.get( id ).args().push( 'v'.mkArg( t, false ) );
							
							id = 'set_single_$domName';
							
							fields.push( id.mkField()
								.mkPublic()
								.toFFun()
								.body( macro {
									var dom = dtx.single.Traversing.children( $i { 'get_$domName' } (), true );
									if (dom.collection.length > pos) {
										dtx.single.ElementManipulation.setAttr( dom.getNode( pos ), $v { attName }, '' + v );
									} else {
										var n = dtx.Tools.create( dtx.single.ElementManipulation.tagName( dom.getNode() ) );
										dtx.single.ElementManipulation.setAttr( n, $v { attName }, '' + v );
										dtx.single.DOMManipulation.append( $i{'get_$domName'}(), n );
									}
								} )
							);
							fields.get( id ).args().push( 'pos'.mkArg( macro: Int, false ) );
							fields.get( id ).args().push( 'v'.mkArg( t, false ) );
							
						case [false, true]:
							fields.push( id.mkField()
								.mkPublic()
								.toFFun()
								.body( macro {
									var dom = dtx.single.Traversing.children( $i { 'get_$domName' }(), true );
									for (i in 0...v.length) {
										//var _v = v[i];
										if (dom.collection.length > i) {
											dtx.single.ElementManipulation.setText( dom.getNode( i ), '' + v[i] );
										} else {
											dom.add( dtx.single.ElementManipulation.setText( dtx.Tools.create( 'div' ), '' + v[i] ), i );
										}
									}
								} )
							);
							fields.get( id ).args().push( 'v'.mkArg( t, false ) );
							
							id = 'set_single_$domName';
							
							fields.push( id.mkField()
								.mkPublic()
								.toFFun()
								.body( macro {
									var dom:dtx.DOMNode = $i { 'get_$domName' } ();
									var children:dtx.DOMCollection = dtx.single.Traversing.children( dom, true );
									if (pos > (children.collection.length-1)) {
										
										var collection:dtx.DOMCollection = new dtx.DOMCollection();
										for (i in 0...(pos - (children.collection.length-1))) {
											collection.add( dtx.Tools.create( dtx.single.ElementManipulation.tagName( children.getNode() ) ) );
										}
										dom.append( null, collection );
										children = dtx.single.Traversing.children( dom, true );
										// TODO create the correct amount of elements and then set the element at `pos` with value of `v`
										dtx.single.ElementManipulation.setText( children.getNode( pos ), '' + v );
									} else {
										dtx.single.ElementManipulation.setText( children.getNode( pos ), '' + v );
									}
								} )
							);
							fields.get( id ).args().push( 'pos'.mkArg( macro: Int, false ) );
							fields.get( id ).args().push( 'v'.mkArg( t, false ) );
							
					}
					
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