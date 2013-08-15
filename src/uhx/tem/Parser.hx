package uhx.tem;

import haxe.rtti.Meta;
#if macro
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
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
				
				TemCommon.TemPlateExprs.push( { expr: ENew( std.Type.enumParameters(ctype)[0], [ macro @:fragment Detox.find( $v{'.'+name} ) ] ), pos: cls.pos } );
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
						trace( t.get().name );
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
						trace( t.get().name );
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
			
			switch (field.kind) {
				case FVar(t, e):
					
					var type = t.toType();
					
					if (type.isIterable()) {
						
						switch ( type ) {
							case TInst(_t, _p):
								
								switch (_t.get().name) {
									case 'Array':
										var td:TypeDefinition = TemCommon.arrayWrapper;
										
										var fs:Array<Field> = [
											td.fields.get( 'arrayWrite' ),
										];
										
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
					
					var extra = macro null;
					
					if (type.isIterable()) {
						
						fields.push( 'prev_TEMVAL_$name'.mkField()
							.mkPublic()
							.toFVar( t )
						);
						
						extra = macro $i { 'prev_TEMVAL_$name' } = $i { name };
						
					}
					
					fields.push( field.mkSetter( macro { 
						$extra;
						$i { name } = v; 
						$i { 'set_${prefix}_$name' } ( v ); 
						return v; } 
					) );
					
					fields.push( 
						'${prefix}_$name'.mkField()
						.mkPublic()
						.toFProp( 'get', 'null', macro: dtx.DOMCollection )
						.addMeta( ':isVar'.mkMeta() )
					);
					
					fields.push( fields.get('${prefix}_$name').mkGetter( macro {
						if ($i { '${prefix}_$name' } == null) {
							$i { '${prefix}_$name' } = dtx.collection.Traversing.find($i { TemCommon.TemDOM.name }, '[$name]');
						}
						return $i { '${prefix}_$name' };
					} ) );
					
					switch ( [attribute, type.isIterable()] ) {
						case [true, false]:
							var id = 'set_${prefix}_$name';
							fields.push( id.mkField()
								.mkPublic()
								.toFFun()
								.body( macro dtx.collection.ElementManipulation.setAttr($i { '${prefix}_$name' }, $v { name }, '' + v) )
							);
							fields.get( id ).args().push( 'v'.mkArg( t, false ) );
							
						case [false, false]:
							var id = 'set_${prefix}_$name';
							fields.push( id.mkField()
								.mkPublic()
								.toFFun()
								.body( macro dtx.collection.ElementManipulation.setText($i { '${prefix}_$name' }, '' + v) )
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
										child = dtx.Tools.parse('<div></dov>');
										// Need to insert a new DOM element, matching the first child's node type.
										// Probably better to create a help class to handle all of this instead of
										// relying on macro generation.
									}
									dtx.single.ElementManipulation.setAttr( child, $v { name }, '' );
								} )
							);
							fields.get( id ).args().push( 'pos'.mkArg( macro: Int, false ) );*/
							
						case [true, true]:
							var id = 'set_${prefix}_$name';
							fields.push( id.mkField()
								.mkPublic()
								.toFFun()
								.body( macro for (_v in v) {
									if ( -1 == Lambda.indexOf( $i { 'prev_TEMVAL_$name' }, _v ) ) {
										for (child in $i { '${prefix}_$name' } ) {
											dtx.single.ElementManipulation.setAttr( child, $v { name }, '' + _v );
										}
									}
								} )
							);
							fields.get( id ).args().push( 'v'.mkArg( t, false ) );
							
						case [false, true]:
							var id = 'set_${prefix}_$name';
							fields.push( id.mkField()
								.mkPublic()
								.toFFun()
								.body( macro for (_v in v) {
									if ( -1 == Lambda.indexOf( $i { 'prev_TEMVAL_$name' }, _v ) ) {
										for (child in $i { '${prefix}_$name' } ) {
											dtx.single.ElementManipulation.setText( child, '' + _v );
										}
									}
								} )
							);
							fields.get( id ).args().push( 'v'.mkArg( t, false ) );
					}
					/*var expr = attribute 
						? macro dtx.collection.ElementManipulation.setAttr($i { '${prefix}_$name' }, $v { name }, '' + v)
						: macro dtx.collection.ElementManipulation.setText($i { '${prefix}_$name' }, '' + v);*/
					
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