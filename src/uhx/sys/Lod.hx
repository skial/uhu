package uhx.sys;

import haxe.ds.StringMap;

using Lambda;
using StringTools;

/**
 * ...
 * @author Skial Bainn
 * lòd => Command in Haitian Creole 
 */
class Lod {
	
	public var args:Array<String>;
	public var seperator:String = ' ';
	
	private var pre:PrevLod;
	private var result:StringMap<Array<String>>;
	
	public function new() {
		
	}
	
	public function parse() {
		if (args == null) throw 'args can not be null';
		
		result = new StringMap<Array<String>>();
		set( 'original', args );
		
		return process( prepare( args ) );
	}
	
	private function prepare(args:Array<String>):Array<String> {
		var nargs:Array<String> = [];
		
		for (arg in args) {
			
			var sep = arg.indexOf( seperator );
			var dquote = arg.indexOf( '"' );
			var squote = arg.indexOf( "'" );
			
			if (sep > -1 && (dquote > -1 || sep < dquote) && (squote > -1 || sep < squote)) {
				
				var key = arg.substr( 0, sep );
				var value = arg.substr( sep );
				
				nargs.push( key );
				nargs.push( value );
				
			} else {
				
				nargs.push( arg );
				if (arg.startsWith( '--no-' )) nargs.push( 'false' );
			}
			
		}
		
		return nargs;
	}
	
	private function process(args:Array<String>):StringMap<Array<String>> {
		for (arg in args) {
			
			// Just dump all remaining args into `argv`
			if (arg == '--') {
				
				var remaining = args.slice( args.indexOf( arg ) );
				set( 'argv', remaining );
				
			} else {
				
				if (arg.startsWith( '--' )) {
					
					// Option eg `--foo`
					arg = arg.replace( '-', '' );
					pre = Option( false, arg );
					
				} else if (arg.startsWith( '-' )) {
					
					// Short hand option eg `-f`
					arg = arg.replace( '-', '' );
					pre = Option( true, arg);
					
				} else {
					
					switch (pre) {
						case Option(_, n):
							set( n, [arg] );
							
						case Value:
							set( 'unmatched', [arg] );
					}
					
					pre = Value;
					
				}
				
			}
			
		}
		
		return result;
	}
	
	private function set(name:String, values:Array<String>) {
		if (result.exists( name )) {
			
			values = result.get( name ).concat( values );
			
		}
		
		result.set( name, values );
	}
	
}

private enum PrevLod {
	
	Value;
	Option(short:Bool, name:String);
	
}