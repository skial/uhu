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

using StringTools;
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
	@alias('o') public var out:String;
	
	public function new(args:Array<String>) {
		trace( args );
		check();
		start();
	}
	
	private function check() {
		lang = lang == null ? 'haxe' : lang;
		dir = dir == null ? Sys.getCwd().normalize() : dir.splitPath().resolve();
		out = out == null ? Sys.getCwd().normalize() : out.splitPath().resolve();
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
	
	/**
	 * something important
	 */
	private function start() {
		var paths:Array<String> = loopDirectory( dir );
		var parser = new HaxeParser();
		for (path in paths) {
			var tokens = parser.tokenise( ByteData.ofString( File.getContent( path ) ), path );
			var html = parser.htmlify( tokens );
			
			trace( path.replace( dir, '' ).split( Path.sep ) );
			trace( dir.split( Path.sep ) );
			trace( out.split( Path.sep ) );
		}
	}
	
}