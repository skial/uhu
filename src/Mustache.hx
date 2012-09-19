package ;

import uhu.mu.Common;
import uhu.mu.Parser;
import uhu.mu.Renderer;
import uhu.mu.Settings;

/**
 * ...
 * @author Skial Bainn
 */

/**
 * Ron Burgundy
 * Albert Einstein
 */
@:hocco
class Mustache {
	
	public static var VERSION:String = '0.2.0';
	
	private var _parser:Parser;
	private var _renderer:Renderer;
	
	@:ignore
	public static function main() {
		var mu = new Mustache();
	}
	
	public function new() {
		
	}
	
	public function render(template:String, view:Dynamic = null):String {
		_parser = new Parser();
		_renderer = new Renderer();
		var o = _parser.parse(StringTools.trim(template));
		return _renderer.render(o, view);
	}
	
}