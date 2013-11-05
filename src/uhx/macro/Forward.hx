package uhx.macro;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using Lambda;
using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class Forward {

	public static function build():Array<Field> {
		return handler( Context.getLocalClass().get(), Context.getBuildFields() );
	}
	
	public static var invalid:Array<String> = ['toString'];
	
	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		for (field in fields) {
			
			if (field.meta.exists( ':forward' )) {
				
				var ftype = field.typeof();
				var cfields = getFields( ftype );
				var meta = field.meta.get( ':forward' );
				
				for (cf in cfields) trace( cf.name );
				
				if (meta.params.length > 0) {
					
					switch (meta.params[0].expr) {
						case EArrayDecl(values):
							var svalues = [for (value in values) value.printExpr()].concat( invalid );
							
							for (cfield in cfields.copy()) {
								if (svalues.indexOf( cfield.name ) < 0) cfields.remove( cfield );
							}
							
							
						case EUnop(_, _, { expr: EArrayDecl(values) } ):
							var svalues = [for (value in values) value.printExpr()].concat( invalid );
							
							for (cfield in cfields.copy()) {
								if (svalues.indexOf( cfield.name ) > -1 || !cfield.isPublic) cfields.remove( cfield );
							}
						
						case _:
							trace( meta.params[0] );
					}
					
				} else {
					for (cfield in cfields.copy()) {
						if (!cfield.isPublic) cfields.remove( cfield );
					}
				}
				
				for (cf in cfields) trace( cf.name );
				
				for (cfield in cfields) {
					
					var nfield = cfield.name.mkField();
					
					switch (cfield.kind) {
						case FVar(r, w):
							// TODO check for property access.
							nfield.toFProp('get', 'set', Context.toComplexType( cfield.type ));
							
							fields.push( nfield.mkGetter( macro {
								return $e {
								Context.parse( '${field.name}.${cfield.name}', field.pos )
									};
							} ) );
							
							fields.push( nfield.mkSetter( macro {
								return $e {
									Context.parse( '${field.name}.${cfield.name} = v', field.pos )
								};
							} ) );
							
						case FMethod(m):
							nfield.toFFun().mkPublic().mkInline().ret( cfield.type.toFFun().getParameters()[0].ret );
							
							var args = nfield.getMethod().args = cfield.type.args().map(function(a) return { value:null, name:a.name, type:Context.toComplexType(a.t), opt:a.opt } );
							
							nfield.body( macro { 
								return $e { 
									Context.parse( '${field.name}.${cfield.name}(${args.map(function(a) return a.name).join(",")})', field.pos ) 
								}; 
							} );
							
					}
					
					fields.push( nfield );
					
				}
				
			}
			
		}
		
		return fields;
	}
	
	private static function getFields(type:Type):Array<ClassField> {
		var result = [];
		
		switch( type ) {
			case TInst(t, _):
				result = t.get().fields.get();
				
			case _:
		}
		
		return result;
	}
	
}