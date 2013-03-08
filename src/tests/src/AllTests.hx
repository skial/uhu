package ;

import haxe.unit.TestRunner;
import uhu.mu.CommentSpec;
import uhu.mu.DelimiterSpec;
import uhu.mu.InterpolationSpec;
import uhu.mu.InvertedSpec;
import uhu.mu.MustacheSpec;
import uhu.mu.PartialSpec;
import uhu.mu.SectionSpec;
import uhu.mu.WalkContextSpec;

import haxe.Utf8Spec;

import sys.net.HostSpec;
import sys.net.SocketSpec;

import uhx.crypto.Base64Spec;
import uhx.crypto.HMACSpec;
import uhx.crypto.MD5Spec;
import uhx.oauth.OAuth10aSpec;
import uhx.util.URLParserSpec;

/**
 * ...
 * @author Skial Bainn
 */

class AllTests {

	public static function main() {
		
		var runner = new TestRunner();
		
		runner.add( new Utf8Spec() );
		
		runner.add( new Base64Spec() );
		runner.add( new MD5Spec() );
		runner.add( new HMACSpec() );
		
		runner.add( new URLParserSpec() );
		
		#if sys
		
		runner.add( new OAuth10aSpec() );
		
		runner.add( new HostSpec() );
		runner.add( new SocketSpec() );
		
		#end
		
		// Mustache tests
		runner.add( new CommentSpec() );
		runner.add( new DelimiterSpec() ); //
		runner.add( new InterpolationSpec() );
		runner.add( new InvertedSpec() );
		runner.add( new MustacheSpec() ); //
		runner.add( new PartialSpec() ); //
		runner.add( new SectionSpec() ); 
		runner.add( new WalkContextSpec() ); 
		
		runner.run();
		
	}
	
}