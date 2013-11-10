package uhx.macro.jumla.a;

import haxe.macro.Type;
import haxe.macro.Expr;
import uhx.macro.jumla.impl.ReferenceImpl;

/**
 * ...
 * @author Skial Bainn
 */
abstract Reference<T>(ReferenceImpl<T>) from ReferenceImpl<T> to ReferenceImpl<T> {
	
	public function new(v:ReferenceImpl<T>) this = v;
	
	@:to public function toField():Field return cast this.field;
	@:to public function toClassField():ClassField return cast this.field;
	
	@:from public static function fromField(v:Field):Reference<Field> return new ReferenceImpl(v);
	@:from public static function fromClassField(v:ClassField):Reference<ClassField> return new ReferenceImpl(v);
	
}