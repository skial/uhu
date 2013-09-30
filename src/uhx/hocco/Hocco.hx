package uhx.hocco;

import haxe.ds.StringMap.StringMap;
import haxe.io.Bytes;
import haxe.io.StringInput;
import hxparse.Lexer;
import hxparse.Parser;
import sys.io.File;
import byte.ByteData;
import uhx.lexer.HaxeLexer;
import uhx.lexer.HaxeParser;

using sys.FileSystem;
using taurine.io.Path;

/**
 * ...
 * @author Skial Bainn
 */
@:cmd
class Hocco implements Klas {
	
	public static function main() {
		new Hocco( Sys.args() );
	}

	@alias('l') public var lang:String;
	@alias('d') public var dir:String;
	
	public function new(args:Array<String>) {
		trace( args );
		check();
		start();
	}
	
	private function check() {
		lang = lang == null ? 'haxe' : lang;
		dir = dir == null ? Sys.getCwd() : dir.splitPath().resolve();
	}
	
	/**
	 * something important
	 */
	private function start() {
		var hx:Array<String> = loopDirectory( dir );
		var content = File.getContent( hx[0] );
		var hp = new HaxeParser( ByteData.ofString( content ), hx[0] );
		trace( hx[0] );
		trace( content.length );
	}
	
	// something
	private function loopDirectory(dir:String):Array<String> {
		var result:Array<String> = [];
		
		if (dir.exists() && dir.isDirectory()) {
			
			var parts = dir.splitPath();
			var path = '';
			
			for (obj in dir.readDirectory()) {
				
				path = parts.concat( [obj] ).resolve();
				
				if ( path.isDirectory() ) {
					
					result = result.concat( loopDirectory( path ) );
					
				} else if( path.extname() == '.hx') {
					
					result.push( path );
					
				}
				
			}
			
		}
		
		return result;
	}
	
}