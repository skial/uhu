package example.thxPromises;

import haxe.Http;
import thx.react.Promise;

/**
 * ...
 * @author Skial Bainn
 */
class Main {
	
	public static function main() {
		var v = null;
		doGet().then( function(vv:String) { trace(vv); } );
		getPostFix!();
	}
	
	public static function getPostFix!() {
		return '';
	}
	
	public static function doGet() {
		var d = new Deferred<String>();
		var h = new Http('https://api.github.com/users/skial');
		h.onStatus = function(s:Int) {
			d.resolve( '$s' );
		}
		h.onError = function(e:String) {
			d.reject( e );
		}
		h.request(false);
		return d.promise;
	}
	
}