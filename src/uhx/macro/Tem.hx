package uhx.macro;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import sys.io.Process;
import uhx.tem.Parser;
import uhx.macro.help.TemCommon;
import uhx.web.URI;

using Xml;
using Detox;
using StringTools;
using sys.io.File;
using sys.FileSystem;
using uhu.macro.Jumla;
#end

/**
 * ...
 * @author Skial Bainn
 */
class Tem {
	
	public static macro function setIndex(path:String):Void {
		path = Context.resolvePath( path ).fullPath();
		var process:Process = new Process('tidy.exe', ['-i', '-q', '-asxml', '--doctype', 'omit', path]);
		var content = process.stdout.readAll().toString();
		TemMacro.html = content.parse();
		process.close();
		
		// This gets called once macro mode has finished
		Context.onGenerate( function(_) {
			
			var output = Compiler.getOutput();
			
			// path parts
			var pparts = path.split( path.indexOf( '/' ) == -1 ? '\\' : '/' );
			
			// output parts
			var oparts = output.split( output.indexOf( '/' ) == -1 ? '\\' : '/' );
			
			var body:Xml = TemMacro.html.find( 'body' ).collection[0];
			
			if (body.find('script[src="' + oparts[oparts.length - 1] + '"]').length == 0) {
				var script:Xml = Xml.createElement( 'script' );
				
				script.set( 'src', oparts[oparts.length - 1] );
				body.addChild( script );
			}
			
			// replaces `output` filename with `path` file name
			oparts[oparts.length - 1] = pparts[pparts.length - 1];
			
			var process:Process = new Process('tidy.exe', ['-utf8', '-q', '-ashtml', '-o', oparts.join( '/' ), '--doctype', 'html5']);
			process.stdin.writeString( TemMacro.html.html() );
			process.close();
			
		} );
	}
	
	public static macro function build():Array<Field> {
		return TemMacro.handler( Context.getLocalClass().get(), Context.getBuildFields() );
	}
	
}

class TemMacro {
	
	#if macro
	public static var html:DOMCollection = null;
	
	public static function handler(cls:ClassType, fields:Array<Field>):Array<Field> {
		
		if (Context.defined( 'display' )) return fields;
		
		if (!cls.isStatic()) {
			
			if (fields.exists('new')) {
				
				var _ts = TemCommon.TemSetup;
				var _et = TemCommon.TemEThis;
				
				//_et.kind = FVar( Context.toComplexType( Context.getType( cls.path() ) ) );
				
				//fields.push( _et );
				fields.push( _ts );
				
				var _new = fields.get('new');
				
				switch (_new.kind) {
					case FFun(m):
						m.args.push( 'fragment'.mkArg( macro: dtx.DOMCollection, true ) );
						
						switch (m.expr.expr) {
							case EBlock( es ):
								es.unshift( macro if (fragment != null) TemSetup( fragment ) );
								
							case _:
						}
						
					case _:
				}
				
				for (f in fields) {
					switch (f.kind) {
						case FFun(m) if (!f.isStatic()):
							switch (m.expr.expr) {
								case EBlock( es ):
									es.unshift( macro var ethis = this );
									
								case _:
							}
							
						case _:
					}
				}
				
			}
			
		} else {
			
			
			
		}
		
		if (!fields.exists( TemCommon.TemDOM.name )) fields.push( TemCommon.TemDOM );
		
		Parser.cls = cls;
		Parser.fields = fields;
		Parser.process( html.find('.${cls.name}'), cls.name );
		
		if (TemCommon.TemPlateExprs.length > 0) {
			
			var ndef = TemCommon.tem;
			var nplate = TemCommon.plate;
			
			nplate.body( { expr:EBlock( TemCommon.TemPlateExprs ), pos: nplate.pos } );
			
			ndef.fields.push( nplate );
			//ndef.fields.push( TemCommon.creation );
			
			Context.defineType( ndef );
			Compiler.exclude( TemCommon.PreviousTem );
			TemCommon.PreviousTem = ndef.path();
			
		}
		
		return fields;
	}
	#end
	
}