package uhx.macro;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using uhu.macro.Jumla;

/**
 * ...
 * @author Skial Bainn
 */
class Bind {

	public static function handler(cls:ClassType, field:Field):Array<Field> {
		var fields = [ field ];
		var meta = field.meta.get( ':bind' );
		var param = meta.params[0];
		
		var type:Type = null;
		var kls:ClassType = null;
		var target:ClassField = null;
		trace(field.kind);
		switch(param.expr) {
			case EField(e, n):
				
				type = Context.getType( e.toString() );
				
				switch (type) {
					case TInst(t, _):
						kls = t.get();
						var _fields = kls.fields.get();
						var _statics = kls.statics.get();
						
						if (_fields.exists( n )) {
							target = _fields.get( n );
						} else if (_statics.exists( n )) {
							target = _statics.get( n );
						}
						
						if (target == null) {
							Context.error('$n was not found in class ${kls.name}', field.pos);
						}
						
					case _:
						trace( type );
				}
				
			case _:
				trace( param );
				Context.error('Only class fields can be bound to and from.', field.pos);
				
		}
		
		
		
		return fields;
	}
	
}